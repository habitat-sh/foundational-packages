$pkg_name="visual-build-tools-2026"
$pkg_origin="core"
$pkg_version="18.8.2"
$pkg_description="Standalone compiler, libraries and scripts"
$pkg_upstream_url="https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2026"
$pkg_license=@("Microsoft Software License")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
# $pkg_source="https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/VisualStudio/BuildTools"
$pkg_source="https://aka.ms/vs/stable/vs_BuildTools.exe"
# When accessing the vs_BuildTools.exe from https://aka.ms/vs/18/release/vs_BuildTools.exe, 
# it always provides the latest version of the build tools, which, in turn, can change dependencies. 
# This may cause issues due to differences in the build time and result in a loss of reproducibility. 
# Instead, we should always use the exact version of the build tools based on the configured version.
# https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/VisualStudio/BuildTools
$pkg_shasum="746102400cd7b88c5ac2ccf66ba5fbcf7357710809be0717cda716bdeff11817"
$pkg_build_deps=@("core/7zip")

$pkg_bin_dirs=@(
    "Contents\VC\Tools\MSVC\14.51.36231\bin\HostX64\x64",
    "Contents\VC\Redist\MSVC\14.51.36231\x64\Microsoft.VC145.CRT",
    "Contents\VC\Redist\MSVC\14.51.36231\x86\Microsoft.VC145.CRT", # For packaged 32 bit cmake
    "Contents\MSBuild\Current\Bin\amd64",
	"Contents\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin",
	"Contents\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
)
$pkg_lib_dirs=@(
    "Contents\VC\Tools\MSVC\14.51.36231\atlmfc\lib\x64",
    "Contents\VC\Tools\MSVC\14.51.36231\lib\x64"
)
$pkg_include_dirs=@(
    "Contents\VC\Tools\MSVC\14.51.36231\atlmfc\include",
    "Contents\VC\Tools\MSVC\14.51.36231\include"
)

function Invoke-SetupEnvironment {
    Set-RuntimeEnv "DisableRegistryUse" "true"
	# Setting this Windows Driver Kit variable is necessary to enable
    # cmake to use this portable build tools package and not query
    # the windows registry or the visual studio installer components
    Set-RuntimeEnv "EnterpriseWDK" "true"
    Set-RuntimeEnv "UseEnv" "true"
    Set-RuntimeEnv "VCToolsVersion" "14.51.36231"
    Set-RuntimeEnv "VisualStudioVersion" "18.0"
    Set-RuntimeEnv -IsPath "VSINSTALLDIR" "$pkg_prefix\Contents"
    Set-RuntimeEnv -IsPath "VCToolsInstallDir_180" "$pkg_prefix\Contents\VC\Redist\MSVC\14.51.36231"
    # This prevents msbuild.exe from running (for 15 minutes) and locking files after a build completes
    Set-RuntimeEnv "MSBUILDDISABLENODEREUSE" "1"
}

<#
NOTE: The VS bootstrapper enforces a hard limit: the layout path must be < 80 characters.
The Habitat studio path is ~130 chars, so we cannot use $HAB_CACHE_SRC_PATH here.
Instead, we will use the top level path of the current working directory to create a layout path that is < 80 characters.
#>

$topLevelLayoutPath = $($pwd.Path -match '^([A-Za-z]:\\([^\\\n]+)?)' | Out-Null; $Matches[1])
$layoutPath = "$topLevelLayoutPath\hab\vst_layout"

# Ensuring we don't leave any previous layout behind, which may cause issues with the current build.
if (Test-Path $layoutPath) {
    Remove-Item -Path $layoutPath -Recurse -Force
    New-Item -ItemType Directory -Path $layoutPath | Out-Null
}
else {
    New-Item -ItemType Directory -Path $layoutPath | Out-Null
}

function Invoke-Unpack {
    # This makes me very sad, but is a necessary evil to get the layout working in docker.
    # In previous VS versions or in a non-docker environment, you should just call the
    # downloaded vs_buildtools.exe with the --layout arguments but that seems to fail
    # in a container. To work around that, we need to extract some data from the installer,
    # download the setup.exe program and then invoke it directly. Note that this will
    # write a 'Unhandled Exception: System.IO.IOException: The parameter is incorrect' error
    # to the console but by this time we have everything we need to proceed.

    Write-Host "Extracting $HAB_CACHE_SRC_PATH/$pkg_filename to $layoutPath"
    7z x "$HAB_CACHE_SRC_PATH/$pkg_filename" -o"$layoutPath"

    $opcInstaller = (Get-Content "$layoutPath\vs_bootstrapper_d15\vs_setup_bootstrapper.config")[0].Split("=")[-1]
    Invoke-WebRequest $opcInstaller -Outfile "$layoutPath\vs_installer.opc"
    7z x "$layoutPath\vs_installer.opc" -o"$layoutPath"
    $installArgs = "layout --quiet --layout $layoutPath --lang en-US --in $layoutPath\vs_bootstrapper_d15\vs_setup_bootstrapper.json"
    $components = @(
		"Microsoft.VisualStudio.Workload.MSBuildTools",
		"Microsoft.VisualStudio.Workload.VCTools",
		"Microsoft.Component.MSBuild",
	 "Microsoft.VisualStudio.Component.VC.CoreBuildTools",
         "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
	 "Microsoft.VisualStudio.Component.VC.ATLMFC",
	 "Microsoft.VisualStudio.Component.VC.CMake.Project"	
    )
    foreach ($component in $components) {
        $installArgs += " --add $component"
    }

    $setup = "$layoutPath\Contents\resources\app\layout\setup.exe"
    Write-Host "Launching $setup with args: $installArgs"
    Start-Process -FilePath $setup -ArgumentList $installArgs.Split(" ") -Wait

    Push-Location $layoutPath
    try {
        Get-ChildItem $layoutPath -Include *.vsix -Exclude @('*x86*', '*.arm.*') -Recurse | ForEach-Object {
            Rename-Item $_ "$_.zip"
            Expand-Archive "$_.zip" vst -Force
        }
    } finally { Pop-Location }

}

function Invoke-Install {
    # vctip.exe sends telemetry data to microsoft and locks files for several minutes after a build
    # One can opt out via a registry setting which is not practical in a habitat context
    # removing the execurtable is the best option here
    #Get-ChildItem -Path "$HAB_CACHE_SRC_PATH\$pkg_dirname\expanded\Contents" -Recurse -Filter "vctip.exe" -Force | Remove-Item -Force
    Copy-Item "$layoutPath\vst\Contents" $pkg_prefix -Force -Recurse
}
