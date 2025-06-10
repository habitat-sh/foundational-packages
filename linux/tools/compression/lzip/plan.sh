pkg_name="lzip"
pkg_origin="core"
pkg_version="1.25"
pkg_description="A lossless data compressor with a user interface similar to the one of gzip or bzip2."
pkg_upstream_url="http://www.nongnu.org/lzip/lzip.html"
pkg_license=('GPL-2.0')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source="http://download.savannah.gnu.org/releases/lzip/lzip-${pkg_version}.tar.gz"
pkg_shasum="09418a6d8fb83f5113f5bd856e09703df5d37bae0308c668d0f346e3d3f0a56f"
pkg_deps=(
	core/glibc
	core/gcc-libs
)
pkg_build_deps=(
	core/gcc
)
pkg_bin_dirs=(bin)

do_build() {
	./configure \
		--prefix="${pkg_prefix}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}
do_check() {
	make check
}
