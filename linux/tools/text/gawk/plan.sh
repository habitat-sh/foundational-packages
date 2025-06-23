program="gawk"

pkg_name="gawk"
pkg_origin="core"
pkg_version="5.3.1"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
The awk utility interprets a special-purpose programming language that makes \
it possible to handle simple data-reformatting jobs with just a few lines of \
code.\
"
pkg_upstream_url="http://www.gnu.org/software/gawk/"
pkg_license=('GPL-3.0-or-later' 'LGPL-2.0-only')
pkg_source="http://ftp.gnu.org/gnu/${program}/${program}-${pkg_version}.tar.gz"
pkg_shasum="fa41b3a85413af87fb5e3a7d9c8fa8d4a20728c67651185bb49c38a7f9382b1e"
pkg_dirname="${program}-${pkg_version}"

pkg_deps=(
	core/glibc
	core/mpfr
	core/gmp
	core/readline
)
pkg_build_deps=(
	core/gettext
	core/gcc
)
pkg_bin_dirs=(bin)
pkg_interpreters=(bin/awk bin/gawk)

do_build() {
	./configure --prefix="$pkg_prefix"
	make
}

do_check() {
	# This currently passes in core-plans CI but may fail on some workstations.
	# Ref: https://github.com/habitat-sh/core-plans/issues/2879
	make check
}

do_install() {
	do_default_install

	# copy license files to package
	install -v -Dm644 ${CACHE_PATH}/COPYING ${pkg_prefix}
	install -v -Dm644 ${CACHE_PATH}/missing_d/COPYING.LIB ${pkg_prefix}
}
