$pkg_name="rust"
$pkg_origin="core"
$pkg_version="1.91.1"
$pkg_description="Safe, concurrent, practical language"
$pkg_upstream_url="https://www.rust-lang.org/"
$pkg_license=@("Apache-2.0", "MIT")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://static.rust-lang.org/dist/rust-$pkg_version-aarch64-pc-windows-msvc.msi"
$pkg_shasum = "9aa4d87363ffeddbf77312cf1f72a3bcf11f1751f95e0b7141cf1c8f8ccde895"
$pkg_deps=@("core/visual-cpp-redist-2022", "core/visual-build-tools-2022", "core/windows-11-sdk")
$pkg_build_deps=@("core/lessmsi")
$pkg_bin_dirs=@("bin")
$pkg_lib_dirs=@("lib")

function Invoke-Unpack {
    mkdir "$HAB_CACHE_SRC_PATH/$pkg_dirname"
    Push-Location "$HAB_CACHE_SRC_PATH/$pkg_dirname"
    try {
        lessmsi x (Resolve-Path "$HAB_CACHE_SRC_PATH/$pkg_filename").Path
    } finally { Pop-Location }
}

function Invoke-Install {
    Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/rust-$pkg_version-aarch64-pc-windows-msvc/SourceDir/Rust/*" "$pkg_prefix" -Recurse -Force
}

function Invoke-Check() {
    (& "$HAB_CACHE_SRC_PATH/$pkg_dirname/rust-$pkg_version-aarch64-pc-windows-msvc/SourceDir/Rust/bin/rustc.exe" --version).StartsWith("rustc $pkg_version")
}
