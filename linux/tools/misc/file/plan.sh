program="file"

pkg_name="file"
pkg_origin="core"
pkg_version="5.46"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
file is a standard Unix program for recognizing the type of data contained in \
a computer file.\
"
pkg_upstream_url="https://www.darwinsys.com/file/"
pkg_license=("LicenseRef-file")
pkg_source="ftp://ftp.astron.com/pub/${program}/${program}-${pkg_version}.tar.gz"
pkg_shasum="c9cc77c7c560c543135edc555af609d5619dbef011997e988ce40a3d75d86088"
pkg_dirname="${program}-${pkg_version}"

pkg_deps=(
	core/glibc
	core/bzip2
	core/xz
	core/zlib
)
pkg_build_deps=(
	core/gcc
)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_pconfig_dirs=(lib/pkgconfig)

do_check() {
	make check
}

do_install() {
	make install

	# copy license files to package
	install -v -Dm644 ${CACHE_PATH}/COPYING ${pkg_prefix}
}
