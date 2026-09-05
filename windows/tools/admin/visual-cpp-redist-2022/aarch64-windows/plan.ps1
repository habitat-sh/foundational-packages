$pkg_name="visual-cpp-redist-2022"
$pkg_origin="core"
$pkg_version="14.44.35208.0"
$pkg_description="Run-time components that are required to run C++ applications that are built by using Visual Studio 2022."
$pkg_upstream_url="https://visualstudio.microsoft.com/downloads/#microsoft-visual-c-redistributable-for-visual-studio-2022"
$pkg_license=@("Microsoft Software License")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://download.visualstudio.microsoft.com/download/pr/d7450eb5-03e1-436d-9e7e-deb5fe4759b3/5139E1440C3A20B92153A4DB561C069A0175AAF76C276C3E5B6F56099EDCF4B0/VC_redist.arm64.exe"
$pkg_shasum="5139e1440c3a20b92153a4db561c069a0175aaf76c276c3e5b6f56099edcf4b0"
$pkg_build_deps=@("core/lessmsi/2.0.1/20260902215152", "core/wix/3.14.1/20260903174546")
$pkg_bin_dirs=@("bin")

function Invoke-Unpack {
    dark -x "$HAB_CACHE_SRC_PATH/$pkg_dirname" "$HAB_CACHE_SRC_PATH/$pkg_filename"
    Push-Location "$HAB_CACHE_SRC_PATH/$pkg_dirname"
    try {
        lessmsi x (Resolve-Path "$HAB_CACHE_SRC_PATH/$pkg_dirname/AttachedContainer\packages\VC_Runtime_arm64\VC_Runtime_arm64.msi").Path
    } finally { Pop-Location }
}

function Invoke-Install {
    Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/VC_Runtime_arm64/SourceDir/System64/*.dll" "$pkg_prefix/bin" -Recurse
}
