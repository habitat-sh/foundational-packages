program="autoconf"
pkg_name="autoconf"
pkg_origin="core"
pkg_version="2.72"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
Autoconf is an extensible package of M4 macros that produce shell scripts to \
automatically configure software source code packages.\
"
pkg_upstream_url="https://www.gnu.org/software/autoconf/autoconf.html"
pkg_license=('GPL-3.0-or-later WITH Autoconf-exception-3.0')
pkg_source="http://ftp.gnu.org/gnu/${pkg_name}/${pkg_name}-${pkg_version}.tar.xz"
pkg_shasum="ba885c1319578d6c94d46e9b0dceb4014caafe2490e437a0dbca3f270a223f5a"

pkg_deps=(
	core/m4
	core/perl
)
pkg_build_deps=(
	core/gcc
	core/zlib
	core/libtool
)

pkg_bin_dirs=(bin)

do_check() {
	# Some of the packages are included to enable test cases:
	# * core/zlib
	# * core/libtool
	# Create a link to echo in coreutils to be used by the pcre2 test case
	ln -sv "$(pkg_path_for coreutils)"/bin/echo /bin/echo

	TESTSUITEFLAGS="-j$(nproc)" make check
}
