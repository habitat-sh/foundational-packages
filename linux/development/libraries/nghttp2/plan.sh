program="nghttp2"

pkg_name="nghttp2"
pkg_origin="core"
pkg_version="1.65.0"
pkg_description="nghttp2 is an open source HTTP/2 C Library."
pkg_upstream_url="https://nghttp2.org/"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('MIT')
pkg_source="https://github.com/${program}/${program}/releases/download/v${pkg_version}/${program}-${pkg_version}.tar.gz"
pkg_shasum="8ca4f2a77ba7aac20aca3e3517a2c96cfcf7c6b064ab7d4a0809e7e4e9eb9914"
pkg_dirname="${program}-${pkg_version}"
pkg_deps=(
	core/glibc
)
pkg_build_deps=(
	core/cunit
	core/gcc
	core/make
	core/python
	core/pkg-config
)

pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_pconfig_dirs=(lib/pkgconfig)

do_build() {
	./configure \
		--prefix="${pkg_prefix}" \
		--enable-lib-only
	make
}

do_check() {
	make check
}

do_install() {
	make install

	# Remove unnecessary folders
	rm -rf "${pkg_prefix:?}"/bin
	rm -rf "${pkg_prefix:?}"/share/nghttp2
}
