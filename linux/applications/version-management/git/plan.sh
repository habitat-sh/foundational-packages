pkg_name="git"
pkg_version="2.54.0"
pkg_origin="core"
pkg_description="Git is a free and open source distributed version control
  system designed to handle everything from small to very large projects with
  speed and efficiency."
pkg_upstream_url="https://git-scm.com/"
pkg_license=('GPL-2.0-only' 'LGPL-2.1-only')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source="https://www.kernel.org/pub/software/scm/git/${pkg_name}-${pkg_version}.tar.gz"
pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="45e8107643a44e3ce46f5665beb35af3932fb0d70017687905ab5d4e3aafa8eb"
pkg_deps=(
	core/bash
	core/cacerts
	core/curl
	core/expat
	core/gettext
	core/gcc-libs
	core/glibc
	core/libpcre2
	core/openssh
	core/openssl
	core/perl
	core/sed
	core/zlib
)
pkg_build_deps=(
	core/coreutils
	core/gawk
	core/gcc
	core/make
	core/python
	core/texinfo
)

pkg_bin_dirs=(bin)

do_prepare() {
	local perl_path
	perl_path="$(pkg_path_for perl)/bin/perl"
	sed -e "s#/usr/bin/perl#$perl_path#g" -i Makefile
}

do_build() {
	./configure \
		--prefix="${pkg_prefix}" \
		--with-gitconfig=/etc/gitconfig \
		--with-perl="$(pkg_path_for perl)/bin/perl" \
		--with-python="$(pkg_path_for python)/bin/python" \
		--with-shell="$(pkg_path_for bash)/bin/sh" \
		--with-openssl \
		--with-libpcre2 \
		--with-zlib
	make -j"$(nproc)"
}

do_check() {
	make test
}

do_install() {
	do_default_install

	# copy license files to package
	install -v -Dm644 ${CACHE_PATH}/COPYING ${pkg_prefix}
}
