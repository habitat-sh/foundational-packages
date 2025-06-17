program="bash"

pkg_name="bash-static"
pkg_origin="core"
major_version="5.2"
patch_version=".37"
pkg_version="${major_version}${patch_version}"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
 Bash is the GNU Project's shell. Bash is the Bourne Again SHell. Bash is an \
sh-compatible shell that incorporates useful features from the Korn shell \
(ksh) and C shell (csh). It is intended to conform to the IEEE POSIX \
P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional \
improvements over sh for both programming and interactive use. In addition, \
most sh scripts can be run by Bash without modification.\
"
pkg_upstream_url="http://www.gnu.org/software/bash/bash.html"
pkg_license=('GPL-3.0-or-later')
pkg_source="http://ftp.gnu.org/gnu/${program}/${program}-${pkg_version}.tar.gz"
pkg_shasum="9599b22ecd1d5787ad7d3b7bf0c59f312b3396d1e281175dd1f8a4014da621ff"
pkg_dirname="${program}-${pkg_version}"
pkg_interpreters=(
	bin/sh
	bin/bash
)
pkg_build_deps=(
	core/glibc
	core/gcc
	core/ncurses
	core/readline
)
pkg_bin_dirs=(bin)

do_build() {
	export CFLAGS="${CFLAGS} -static"
	./configure -C \
		--prefix="$pkg_prefix" \
		--without-bash-malloc \
		--enable-static-link
	make
}

do_install() {
	make install
	ln -sv bash "$pkg_prefix/bin/sh"

	# Remove unnecessary binaries
	rm -v "${pkg_prefix}/bin/bashbug"
}
