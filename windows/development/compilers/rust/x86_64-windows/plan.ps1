$pkg_name="rust"
$pkg_origin="core"
$pkg_version="1.98.0"
$pkg_description="Safe, concurrent, practical language"
$pkg_upstream_url="https://www.rust-lang.org/"
$pkg_license=@("Apache-2.0", "MIT")
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://static.rust-lang.org/dist/rust-$pkg_version-x86_64-pc-windows-msvc.msi"
$pkg_shasum = "190bdf9f2916d1b60f31e18bf7c7fb8c7f5fa6e9788773643dbfc9d5266880c3"
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
    Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/rust-$pkg_version-x86_64-pc-windows-msvc/SourceDir/Rust/*" "$pkg_prefix" -Recurse -Force
}

function Invoke-Check() {
    (& "$HAB_CACHE_SRC_PATH/$pkg_dirname/rust-$pkg_version-x86_64-pc-windows-msvc/SourceDir/Rust/bin/rustc.exe" --version).StartsWith("rustc $pkg_version")
}
