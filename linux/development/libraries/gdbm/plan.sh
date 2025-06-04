pkg_name="gdbm"
pkg_origin="core"
pkg_version="1.24"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
GNU dbm is a set of database routines that use extensible hashing. It works \
similar to the standard UNIX dbm routines.\
"
pkg_upstream_url="http://www.gnu.org/software/gdbm/gdbm.html"
pkg_license=('GPL-3.0-or-later')
pkg_source="http://ftp.gnu.org/gnu/$pkg_name/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="695e9827fdf763513f133910bc7e6cfdb9187943a4fec943e57449723d2b8dbf"
pkg_deps=(
	core/glibc
	core/readline
)
pkg_build_deps=(
	core/bison
	core/dejagnu-stage1
	core/flex
	core/gcc
	core/gzip
)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)

do_build() {
	./configure \
		--prefix="$pkg_prefix" \
		--enable-libgdbm-compat
	make
}

do_check() {
	make check
}

do_install() {
	do_default_install

	# create symlinks for compatibility
	install -dm755 "$pkg_prefix/include/gdbm"
	ln -sf ../gdbm.h "$pkg_prefix/include/gdbm/gdbm.h"
	ln -sf ../ndbm.h "$pkg_prefix/include/gdbm/ndbm.h"
	ln -sf ../dbm.h "$pkg_prefix/include/gdbm/dbm.h"
}
