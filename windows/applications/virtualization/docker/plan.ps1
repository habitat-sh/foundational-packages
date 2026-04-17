$pkg_name = "docker"
$pkg_description = "The Docker Engine"
$pkg_origin = "core"
$pkg_version = "29.4.0"
$pkg_maintainer = "The Habitat Maintainers <humans@habitat.sh>"
$pkg_license = @("Apache-2.0")
$pkg_source = "https://download.docker.com/win/static/stable/x86_64/$pkg_name-$pkg_version.zip"
$pkg_upstream_url = "https://docs.docker.com/engine/installation/binaries/"
$pkg_shasum = "a788f9ff37af446419a24eaf579da5c3da59995c708e6a5c908fe21519845b01"
$pkg_dirname = "docker"
$pkg_bin_dirs = @("bin")

function Invoke-Unpack {
    Expand-Archive -Path "$HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version.zip" -DestinationPath "$HAB_CACHE_SRC_PATH/$pkg_dirname"
}

function Invoke-Install {
    Copy-Item docker/* "$pkg_prefix/bin" -Recurse -Force
}
