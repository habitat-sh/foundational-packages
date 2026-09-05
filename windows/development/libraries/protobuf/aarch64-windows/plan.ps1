$pkg_name="protobuf"
$pkg_origin="core"
$pkg_version="3.27.3"
$pkg_file_name=$pkg_name + ($pkg_version).Replace(".", "")
$pkg_description="Protocol buffers are a language-neutral, platform-neutral extensible mechanism for serializing structured data."
$pkg_upstream_url="https://developers.google.com/protocol-buffers/"
$pkg_license=("BSD")
$pkg_source="https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${pkg_version}.zip"
$pkg_shasum="dda7464336f1f8072ce087b4d7c2d3647d57961b0fd38ebf6308e8417c18ac85"
$pkg_deps=@(
    "core/zlib/1.3.2/20260903195141"
)
$pkg_build_deps=@(
    "core/visual-build-tools-2022/17.14.7/20260902211757",
	"core/windows-11-sdk/10.0.26100/20260902220215",
	"core/git/2.55.0/20260903200032"
)
$pkg_bin_dirs=@("bin")
$pkg_lib_dirs=@("lib")
$pkg_include_dirs=@("include")



function Invoke-Build {
	git clone -b lts_2023_08_02 https://github.com/abseil/abseil-cpp.git $HAB_CACHE_SRC_PATH\$pkg_name-$pkg_version\$pkg_name-$pkg_version\third_party/abseil-cpp
    Set-Location "$pkg_name-$pkg_version\cmake"

    $zlib_libdir = "$(Get-HabPackagePath zlib)\lib\z.lib"
    $zlib_includedir = "$(Get-HabPackagePath zlib)\include"

    mkdir build
    Set-Location build
    cmake -G "Visual Studio 17 2022" -A ARM64 -T "v143" -DCMAKE_SYSTEM_VERSION="10.0" -DCMAKE_INSTALL_PREFIX="${pkg_prefix}" -DZLIB_LIBRARY_RELEASE="${zlib_libdir}" -DZLIB_INCLUDE_DIR="${zlib_includedir}" -Dprotobuf_BUILD_TESTS=OFF ../../ 
    # We'll build the required parts here
    msbuild /p:Configuration=Release /p:Platform=ARM64 "INSTALL.vcxproj"
    if($LASTEXITCODE -ne 0) { Write-Error "msbuild failed!" }
}
