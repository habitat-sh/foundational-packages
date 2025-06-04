pkg_name="libxcrypt"
pkg_origin="core"
pkg_version="4.4.38"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="An easy to use, platform independent, interface \
to the Linux Kernel's syscall filtering mechanism."
pkg_upstream_url="https://github.com/seccomp/libseccomp"
pkg_license=('LGPL-2.1')
pkg_source="https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz"
pkg_shasum="80304b9c306ea799327f01d9a7549bdb28317789182631f1b54f4511b4206dd6"

pkg_deps=(
	core/glibc
)
pkg_build_deps=(
	core/build-tools-perl
	core/gcc
)

pkg_include_dirs=(include)
pkg_lib_dirs=(lib)


do_build() {
	./configure --prefix=${pkg_prefix} \
		--disable-static \
		--enable-hashes=strong,glibc \
		--enable-obsolete-api=no \
		--disable-failure-tokens  
	make
}

do_check() {
	make check
}

do_install() {
	make install
}

