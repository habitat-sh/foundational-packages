pkg_name="libiconv"
pkg_origin="core"
pkg_version="1.18"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="Some programs, like mailers and web browsers, must be able to convert \
between a given text encoding and the user's encoding.  Other programs \
internally store strings in Unicode, to facilitate internal processing, \
and need to convert between internal string representation (Unicode) \
and external string representation (a traditional encoding) when they \
are doing I/O.  GNU libiconv is a conversion library for both kinds of \
applications."
pkg_upstream_url="https://www.gnu.org/software/libiconv/"
pkg_license=('GPL-3.0-or-later' 'LGPL-2.0-or-later')
pkg_source="https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${pkg_version}.tar.gz"
pkg_shasum="3b08f5f4f9b4eb82f151a7040bfd6fe6c6fb922efe4b1659c66ea933276965e8"

pkg_deps=(
	core/glibc
)
pkg_build_deps=(
	core/gcc
)

pkg_include_dirs=(include)
pkg_lib_dirs=(lib)

do_build() {
	./configure --prefix="${pkg_prefix}"
	make
}

do_check() {
	make check
}
