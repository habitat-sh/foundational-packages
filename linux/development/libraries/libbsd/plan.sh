pkg_name="libbsd"
pkg_origin="core"
pkg_version="0.12.2"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
This library provides useful functions commonly found on BSD systems, and \
lacking on others like GNU systems\
"
pkg_upstream_url="https://libbsd.freedesktop.org/wiki/"
# https://cgit.freedesktop.org/libbsd/tree/COPYING
pkg_license=('BSD-3-Clause' 'BSD-4-Clause' 'BSD-2-Clause-NetBSD' 'ISC' 'Beerware' 'LicenseRef-Public-Domain')
pkg_source="https://libbsd.freedesktop.org/releases/${pkg_name}-${pkg_version}.tar.xz"
pkg_shasum="b88cc9163d0c652aaf39a99991d974ddba1c3a9711db8f1b5838af2a14731014"

pkg_deps=(
	core/glibc
	core/libmd
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

do_install() {
	do_default_install

	# Install license file from README
	install -Dm644 COPYING "${pkg_prefix}/share/licenses/LICENSE"
}
