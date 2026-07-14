$pkg_name = "docker"
$pkg_description = "The Docker Engine"
$pkg_origin = "core"
$pkg_version = "29.6.0"
$pkg_maintainer = "The Habitat Maintainers <humans@habitat.sh>"
$pkg_license = @("Apache-2.0")
$pkg_source = "https://download.docker.com/win/static/stable/x86_64/$pkg_name-$pkg_version.zip"
$pkg_upstream_url = "https://docs.docker.com/engine/installation/binaries/"
$pkg_shasum = "431f3aeb1f51d206515754f24e1ff889ef3bb2fc1a794d291a973b4ae19af8d9"
$pkg_dirname = "docker"
$pkg_bin_dirs = @("bin")

function Invoke-Unpack {
    Expand-Archive -Path "$HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version.zip" -DestinationPath "$HAB_CACHE_SRC_PATH/$pkg_dirname"
}

function Invoke-Install {
    Copy-Item docker/* "$pkg_prefix/bin" -Recurse -Force
}
