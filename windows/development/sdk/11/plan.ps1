$pkg_name="windows-11-sdk"
$pkg_origin="core"
$pkg_version="10.0.26100"
$pkg_description="The Windows Software Development Kit (10.1.26100.4188) for Windows 11 provides the latest headers, libraries, metadata, and tools for building Windows apps."
$pkg_upstream_url="https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk"
$pkg_license=@("Microsoft Software License")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://download.microsoft.com/download/d05f36da-93d2-4b21-9f1a-555b094f7469/KIT_BUNDLE_WINDOWSSDK_MEDIACREATION/winsdksetup.exe"
$pkg_shasum="cd2f2d69a1913b70e77d52ffd3295bd30e19b3f865a59c3f9b6fae8d852e961d"
$pkg_build_deps=@("core/lessmsi")

$pkg_bin_dirs=@(
    "Windows Kits\10\bin\x64",
    "Windows Kits\10\bin\$pkg_version.0\x64"
)
$pkg_lib_dirs=@(
    "Windows Kits\10\Lib\$pkg_version.0\um\x64",
    "Windows Kits\10\Lib\$pkg_version.0\ucrt\x64"
)
$pkg_include_dirs=@(
    "Windows Kits\10\Include\$pkg_version.0\shared",
    "Windows Kits\10\Include\$pkg_version.0\ucrt",
    "Windows Kits\10\Include\$pkg_version.0\um",
    "Windows Kits\10\Include\$pkg_version.0\winrt"
)

function Invoke-SetupEnvironment {
    Set-RuntimeEnv -IsPath "WindowsSdkDir_10" "$pkg_prefix\Windows Kits\10"
}

function Invoke-Unpack {
    Start-Process "$HAB_CACHE_SRC_PATH/$pkg_filename" -Wait -ArgumentList "/features OptionId.DesktopCPPx64 /quiet /layout $HAB_CACHE_SRC_PATH/$pkg_dirname"
    Push-Location "$HAB_CACHE_SRC_PATH/$pkg_dirname"
    try {
        Get-ChildItem "$HAB_CACHE_SRC_PATH/$pkg_dirname/installers" -Include *.msi -Recurse | ForEach-Object {
            lessmsi x $_
        }
    } finally { Pop-Location }
    Get-ChildItem "$HAB_CACHE_SRC_PATH/$pkg_dirname" -Include @("x86", "arm", "arm64") -Recurse | ForEach-Object {
        Remove-Item $_ -Recurse -Force
    }
}

function Invoke-Install {
    Get-ChildItem "$HAB_CACHE_SRC_PATH/$pkg_dirname" -Include "Windows Kits" -Recurse | ForEach-Object {
        Copy-Item $_ "$pkg_prefix" -Exclude "*.duplicate*" -Recurse -Force
    }
}
