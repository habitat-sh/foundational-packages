program="xz"

pkg_name="xz"
pkg_origin="core"
pkg_version="5.8.3"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
XZ Utils is free general-purpose data compression software with a high \
compression ratio. XZ Utils were written for POSIX-like systems, but also \
work on some not-so-POSIX systems. XZ Utils are the successor to LZMA Utils.\
"
pkg_upstream_url="http://tukaani.org/xz/"
pkg_license=('GPL-2.0-or-later' 'LGPL-2.0-or-later')
pkg_source="http://tukaani.org/${program}/${program}-${pkg_version}.tar.gz"
pkg_shasum="3d3a1b973af218114f4f889bbaa2f4c037deaae0c8e815eec381c3d546b974a0"
pkg_dirname="${program}-${pkg_version}"

pkg_deps=(
	core/glibc
)
pkg_build_deps=(
	core/gcc
	core/build-tools-gettext
)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_pconfig_dirs=(lib/pkgconfig)

do_build() {
	./configure \
		--prefix="$pkg_prefix" \
		--docdir="$pkg_prefix"/share/doc/xz-5.2.6

	make
}

do_check() {
	make check
}

do_install() {
	make install

	# copy license files to package
	install -v -Dm644 ${CACHE_PATH}/COPYING* ${pkg_prefix}
}
