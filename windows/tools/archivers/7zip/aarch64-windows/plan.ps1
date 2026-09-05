$pkg_name="7zip"
$pkg_origin="core"
$pkg_version="26.01"
$pkg_license=@("LGPL-2.1", "unRAR restriction")
$pkg_upstream_url="https://www.7-zip.org/"
$pkg_description="7-Zip is a file archiver with a high compression ratio"
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://github.com/ip7z/7zip/releases/download/$pkg_version/7z$($pkg_version.Replace('.',''))-arm64.exe"
$pkg_shasum="1fecf4e3407950939c8ffcc3e42e3039821997dea155301c75369474e5f15175"
$pkg_filename="7z$($pkg_version.Replace('.',''))-arm64.exe"
$pkg_bin_dirs=@("bin")

function Invoke-Unpack {
    Start-Process "$HAB_CACHE_SRC_PATH/$pkg_filename" -Wait -ArgumentList "/S /D=`"$(Resolve-Path $HAB_CACHE_SRC_PATH)/$pkg_dirname`""
}

function Invoke-Install {
    Copy-Item * "$pkg_prefix/bin" -Recurse -Force
}
