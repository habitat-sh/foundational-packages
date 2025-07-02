$pkg_name="visual-cpp-redist-2022"
$pkg_origin="core"
$pkg_version="14.44.35208.0"
$pkg_description="Run-time components that are required to run C++ applications that are built by using Visual Studio 2022."
$pkg_upstream_url="https://visualstudio.microsoft.com/downloads/#microsoft-visual-c-redistributable-for-visual-studio-2022"
$pkg_license=@("Microsoft Software License")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://download.visualstudio.microsoft.com/download/pr/40b59c73-1480-4caf-ab5b-4886f176bf71/D62841375B90782B1829483AC75695CCEF680A8F13E7DE569B992EF33C6CD14A/VC_redist.x64.exe"
$pkg_shasum="d62841375b90782b1829483ac75695ccef680a8f13e7de569b992ef33c6cd14a"
$pkg_build_deps=@("core/lessmsi", "core/wix")
$pkg_bin_dirs=@("bin")

function Invoke-Unpack {
    dark -x "$HAB_CACHE_SRC_PATH/$pkg_dirname" "$HAB_CACHE_SRC_PATH/$pkg_filename"
    Push-Location "$HAB_CACHE_SRC_PATH/$pkg_dirname"
    try {
        lessmsi x (Resolve-Path "$HAB_CACHE_SRC_PATH/$pkg_dirname/AttachedContainer\packages\vcRuntimeMinimum_amd64\vc_runtimeMinimum_x64.msi").Path
    } finally { Pop-Location }
}

function Invoke-Install {
    Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/vc_runtimeMinimum_x64/SourceDir/system64/*.dll" "$pkg_prefix/bin" -Recurse
}
