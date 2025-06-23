program="cmake"

pkg_name="cmake"
pkg_origin="core"
pkg_version="4.0.3"
pkg_maintainer='The Habitat Maintainers <humans@habitat.sh>'
pkg_license=('BSD-3-Clause')
pkg_description="CMake is an open-source, cross-platform family of tools designed to build, test and package software"
pkg_upstream_url="https://cmake.org/"
pkg_source="https://github.com/Kitware/CMake/releases/download/v${pkg_version}/cmake-${pkg_version}.tar.gz"
pkg_shasum="8d3537b7b7732660ea247398f166be892fe6131d63cc291944b45b91279f3ffb"
pkg_dirname="${program}-${pkg_version}"
pkg_deps=(
	core/bzip2
	core/curl
	core/expat
	core/glibc
	core/gcc-libs
	core/jsoncpp
	core/libarchive
	core/libuv
	core/nghttp2
	core/librhash
	core/ncurses
	core/openssl
	core/xz
	core/zlib
	core/zstd
	core/coreutils
)
pkg_build_deps=(
	core/gcc
	core/cmake-stage1
)

pkg_bin_dirs=(bin)

do_prepare() {
	# Add package prefix paths to the CMAKE_PREFIX_PATH so that cmake is able
	# to find binaries, libraries and headers
	CMAKE_PREFIX_PATH=$(join_by ";" "${pkg_all_deps_resolved[@]}")
	build_line "Setting CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
	# Prevents applications using cmake from attempting to install files in /usr/lib64
	sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake
}

do_build() {
	mkdir build
	pushd build || exit 1
	cmake .. \
		--install-prefix="${pkg_prefix}" \
		-DCMAKE_USE_SYSTEM_LIBRARY_CURL=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_EXPAT=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_ZLIB=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_BZIP2=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_LIBLZMA=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_NGHTTP2=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_ZSTD=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_LIBARCHIVE=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_LIBRHASH=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_LIBUV=ON \
		-DCMAKE_USE_SYSTEM_LIBRARY_CPPDAP=OFF \
		-DCMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}" \
		-DBUILD_CursesDialog=ON \
		-DCURSES_NEED_NCURSES=TRUE \
		-DCURSES_NEED_WIDE=TRUE
	cmake --build . --parallel "$(nproc)"
	popd || exit 1
}

do_check() {
	pushd build || exit 1
	# Skip tests that will fail due to habitat build environment
	make ARGS="-E '^(StagingPrefix|BundleUtilities|BootstrapTest|RunCMake\.RuntimePath)'" test
	popd || exit 1
}

do_install() {
	pushd build || exit 1
	cmake --install .
	popd || exit 1

	# fix for interpreter
	sed -e "s,/usr/bin/env,$(pkg_interpreter_for coreutils bin/env),g" -i ${pkg_prefix}/share/cmake-4.0/Modules/Compiler/XL-Fortran/cpp

	# copy license files in package
	install -v -Dm644 ${CACHE_PATH}/LICENSE.rst ${pkg_prefix}
	install -v -Dm644 ${CACHE_PATH}/Licenses/* ${pkg_prefix}
}
