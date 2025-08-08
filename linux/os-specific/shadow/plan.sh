program="shadow"

pkg_name="shadow"
pkg_origin="core"
pkg_version="4.17.4"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
Password and account management tool suite.
"
pkg_upstream_url="https://github.com/shadow-maint/shadow"
pkg_license=('Artistic-1.0')
pkg_source="https://github.com/shadow-maint/${pkg_name}/releases/download/${pkg_version}/${pkg_name}-${pkg_version}.tar.xz"
pkg_shasum="554801054694ff7d8a7abdf0d6ece34e2f16e111673cc01b8c9ee1278451181e"
pkg_dirname="${program}-${pkg_version}"

pkg_deps=(
	core/glibc
	core/attr
	core/acl
	core/libxcrypt
)

pkg_build_deps=(
	core/gcc
)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)

do_prepare() {
	# Disable the installation of the `groups` program as Coreutils provides a
	# better version.
	#
	# Thanks to:
	# http://www.linuxfromscratch.org/lfs/view/stable/chapter06/shadow.html
	# shellcheck disable=SC201
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
	find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
	find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;

	# Instead of using the default crypt method, use the more secure SHA-512
	# method of password encryption, which also allows passwords longer than 8
	# characters.
	#
	# Thanks to:
	# http://www.linuxfromscratch.org/lfs/view/stable/chapter06/shadow.html
	sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
		-e 's:/var/spool/mail:/var/mail:' \
		-e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
		-i etc/login.defs

}

do_build() {
	./configure --sysconfdir="${pkg_prefix}/etc" \
		--with-{b,yes}crypt \
		--without-libbsd \
		--with-group-name-max-length=32

	make
}

do_install() {
	make exec_prefix="${pkg_prefix}" install

	# Move all binaries in `sbin/` into `bin/` as this isn't handled by
	# `./configure`.
	mv "$pkg_prefix/sbin"/* "$pkg_prefix/bin/"
	rm -rf "$pkg_prefix/sbin"

	# copy license files to package
	install -v -Dm644 ${CACHE_PATH}/COPYING ${pkg_prefix}
}
