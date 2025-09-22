pkg_name="sqlite"
pkg_version="3.50.4"
pkg_dist_version="3500400"
pkg_origin="core"
pkg_license=('LicenseRef-Public-Domain' 'BSD-2-Clause-Views')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="A software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
pkg_upstream_url=https://www.sqlite.org/
pkg_source="https://www.sqlite.org/2025/${pkg_name}-autoconf-${pkg_dist_version}.tar.gz"
pkg_filename="${pkg_name}-autoconf-${pkg_dist_version}.tar.gz"
pkg_dirname="${pkg_name}-autoconf-${pkg_dist_version}"
pkg_shasum="a3db587a1b92ee5ddac2f66b3edb41b26f9c867275782d46c3a088977d6a5b18"
pkg_deps=(
	core/glibc
	core/readline
	core/zlib
)
pkg_build_deps=(
	core/coreutils
	core/gawk
	core/gcc
	core/grep
	core/make
	core/sed
)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)

do_install() {
	do_default_install

	# source tarball does not have license files
}
