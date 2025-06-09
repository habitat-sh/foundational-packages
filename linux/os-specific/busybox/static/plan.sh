pkg_name="busybox-static"
pkg_origin="core"
pkg_version="1.37.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('GPL-2.0-only' 'bzip2-1.0.6')
pkg_source="https://busybox.net/downloads/busybox-${pkg_version}.tar.bz2"
pkg_shasum="3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4"
pkg_dirname="busybox-${pkg_version}"
pkg_bin_dirs=(bin)
pkg_interpreters=(
	bin/ash
	bin/awk
	bin/env
	bin/sh
	bin/bash
)

pkg_build_deps=(
	core/bzip2
	core/gcc
)

do_prepare() {
	export LDFLAGS="--static"

	build_line "Setting LDFLAGS=${LDFLAGS}"
}

do_build() {
	make defconfig
	make -j"$(nproc)"
}

do_install() {
	install -Dm755 busybox "$pkg_prefix/bin/busybox"

	# Generate the symlinks back to the `busybox` executable
	for l in $(busybox --list); do
		ln -sv busybox "$pkg_prefix/bin/$l"
	done

	# copy license files in package
	install -Dm644 ${CACHE_PATH}/LICENSE ${pkg_prefix}
	#install -Dm644 ${CACHE_PATH}/archival/libarchive/bz/LICENSE ${pkg_prefix}
}