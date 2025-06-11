program="automake"
pkg_name="automake"
pkg_origin="core"
pkg_version="1.17"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
Automake is a tool for automatically generating Makefile.in files compliant \
with the GNU Coding Standards.\
"
pkg_upstream_url="https://www.gnu.org/software/automake/"
pkg_license=('GPL-2.0-or-later' 'LGPL-2.1-or-later')
pkg_source="http://ftp.gnu.org/gnu/${pkg_name}/${pkg_name}-${pkg_version}.tar.xz"
pkg_shasum="8920c1fc411e13b90bf704ef9db6f29d540e76d232cb3b2c9f4dc4cc599bd990"

pkg_deps=(
	core/perl
	core/autoconf
)
pkg_build_deps=(
	core/bison
	core/gcc
	core/flex
	core/gzip
	core/lzip
	core/libtool
	core/tar
	core/zstd
	core/dejagnu-stage1
	core/build-tools-texinfo
	core/pkg-config
)

pkg_bin_dirs=(bin)

do_check() {
	# List of packages required for test cases
	# * core/gzip
	# * core/libtool
	# * core/flex
	# * core/lzip
	# * core/pkg-config
	# * core/tar
	# * core/zstd
	# * core/dejagnu-stage1
	# * core/build-tools-texinfo
	make -j"$(nproc)" check
}
