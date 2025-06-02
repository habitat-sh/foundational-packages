program="readline"

pkg_name="readline"
pkg_origin="core"
pkg_version="8.2.13"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="The GNU Readline library provides a set of functions for use by applications \
that allow users to edit command lines as they are typed in."
pkg_upstream_url="http://tiswww.case.edu/php/chet/readline/rltop.html"
pkg_license=('GPL-3.0-only')
pkg_source="http://ftp.gnu.org/gnu/${program}/${program}-${pkg_version}.tar.gz"
pkg_shasum="0e5be4d2937e8bd9b7cd60d46721ce79f88a33415dd68c2d738fb5924638f656"
pkg_dirname="${program}-${pkg_version}"

pkg_deps=(
	core/glibc
	core/ncurses
)

pkg_build_deps=(
	core/gcc
)

pkg_include_dirs=(include)
pkg_lib_dirs=(lib)

do_build() {
	./configure \
		--prefix="$pkg_prefix" \
		--disable-bracketed-paste-default \
		--with-curses \
		--docdir="$pkg_prefix"/share/doc/readline-8.2
	make SHLIB_LIBS="-lncursesw"
}

do_check() {
	make check
}

do_install() {
	make install

	# remove unnecessary folder
	rm -rf "${pkg_prefix}/bin"
	# install documentation
	install -v -m644 doc/*.{ps,pdf,html,dvi} "${pkg_prefix}"/share/doc/readline-8.2
}
