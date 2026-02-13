$pkg_name = "docker"
$pkg_description = "The Docker Engine"
$pkg_origin = "core"
$pkg_version = "29.2.1"
$pkg_maintainer = "The Habitat Maintainers <humans@habitat.sh>"
$pkg_license = @("Apache-2.0")
$pkg_source = "https://download.docker.com/win/static/stable/x86_64/$pkg_name-$pkg_version.zip"
$pkg_upstream_url = "https://docs.docker.com/engine/installation/binaries/"
$pkg_shasum = "5a9c58d0438139940b7116b671f16a87c966caf923916fadcfab311c574f45b6"
$pkg_dirname = "docker"
$pkg_bin_dirs = @("bin")

function Invoke-Unpack {
    Expand-Archive -Path "$HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version.zip" -DestinationPath "$HAB_CACHE_SRC_PATH/$pkg_dirname"
}

function Invoke-Install {
    Copy-Item docker/* "$pkg_prefix/bin" -Recurse -Force
}
