$pkg_name="zlib"
$pkg_origin="core"
$pkg_version="1.3.2"
$pkg_file_name=$pkg_name + ($pkg_version).Replace(".", "")
$pkg_description="Compression library implementing the deflate compression method found in gzip and PKZIP."
$pkg_upstream_url="http://www.zlib.net/"
$pkg_license=("zlib")
$pkg_source="https://github.com/madler/zlib/archive/refs/tags/v$pkg_version.zip"

$pkg_shasum="31fd9fee98812abcf147d0e103bc4d2f983c35a8d7a807a328a299f3a74e0050"
$pkg_build_deps=@("core/visual-build-tools-2022/17.14.7/20260902211757", "core/windows-11-sdk/10.0.26100/20260902220215")
$pkg_bin_dirs=@("bin")
$pkg_lib_dirs=@("lib")
$pkg_include_dirs=@("include")

function Invoke-Build {
	
	Set-Location "$pkg_name-$pkg_version"
	# zlib 1.3.2 requires cmake for building.
	mkdir cmake-build
    Set-Location cmake-build
    cmake -G "Visual Studio 17 2022" -A "ARM64" -T "v143" -DCMAKE_SYSTEM_VERSION="10.0" -DCMAKE_INSTALL_PREFIX="${prefix_path}\zlib" ..
    msbuild /p:Configuration=Release /p:Platform=ARM64 "zlib.sln"
    if($LASTEXITCODE -ne 0) { Write-Error "msbuild failed!" }
}

function Invoke-Install {
    
	Copy-Item "$HAB_CACHE_SRC_PATH\$pkg_name-$pkg_version\$pkg_name-$pkg_version\cmake-build\Release\z.dll" "$pkg_prefix\bin\z.dll" -Force
    Copy-Item "$HAB_CACHE_SRC_PATH\$pkg_name-$pkg_version\$pkg_name-$pkg_version\cmake-build\Release\z.lib" "$pkg_prefix\lib\z.lib" -Force
    Copy-Item "$HAB_CACHE_SRC_PATH\$pkg_name-$pkg_version\$pkg_name-$pkg_version\zlib.h" "$pkg_prefix\include\" -Force
    Copy-Item "$HAB_CACHE_SRC_PATH\$pkg_name-$pkg_version\$pkg_name-$pkg_version\zconf.h" "$pkg_prefix\include\" -Force

}
