pkg_name="libmd"
pkg_origin="core"
pkg_version="1.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="BSD Mesage Digest library"
pkg_upstream_url="https://www.hadrons.org/software/libmd"
# https://git.hadrons.org/cgit/libmd.git/tree/COPYING
pkg_license=('BSD-3-Clause' 'BSD-2-Clause' 'BSD-2-Clause-NetBSD' 'ISC' 'Beerware' 'LicenseRef-Public-Domain')
pkg_source="https://archive.hadrons.org/software/libmd/libmd-${pkg_version}.tar.xz"
pkg_shasum="1bd6aa42275313af3141c7cf2e5b964e8b1fd488025caf2f971f43b00776b332"

pkg_deps=(
	core/glibc
)
pkg_build_deps=(
	core/gcc
)

pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_pconfig_dirs=(lib/pkgconfig)

do_check() {
	make check
}
