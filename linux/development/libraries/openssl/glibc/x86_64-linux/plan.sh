program="openssl"

pkg_name="openssl"
pkg_origin="core"
pkg_version="3.5.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
OpenSSL is an open source project that provides a robust, commercial-grade, \
and full-featured toolkit for the Transport Layer Security (TLS) and Secure \
Sockets Layer (SSL) protocols. It is also a general-purpose cryptography \
library.\
"
pkg_upstream_url="https://www.openssl.org"
pkg_license=('Apache-2.0')
pkg_source="https://www.openssl.org/source/${program}-${pkg_version}.tar.gz"
pkg_shasum="344d0a79f1a9b08029b0744e2cc401a43f9c90acd1044d09a530b4885a8e9fc0"
pkg_dirname="${program}-${pkg_version}"
pkg_deps=(
	core/glibc
	core/cacerts
)
pkg_build_deps=(
	core/coreutils
	core/gcc
	core/grep
	core/make
	core/sed
	core/patch
	core/build-tools-perl
	core/openssl-stage1
)

pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib64)
pkg_pconfig_dirs=(lib64/pkgconfig)

_common_prepare() {
	do_default_prepare
	# Make cert.pem to get from the cacerts hab package.
	# Fix for net/protocol.rb:46:in `connect_nonblock': SSL_connect returned=1 errno=0 peeraddr=xxx.xx.xx.xx:443 state=error:
	# certificate verify failed (unable to get local issuer certificate) (OpenSSL::SSL::SSLError)\n"
	# ruby -ropenssl -e 'puts OpenSSL::X509::DEFAULT_CERT_FILE' to return our cacerts path.
	# Set CA dir to `$pkg_prefix/ssl` by default and use the cacerts from the
	# `cacerts` package. Note that `patch(1)` is making backups because
	# we need an original for the test suite.
	# DO NOT REMOVE
	sed -e "s,@cacerts_prefix@,$(pkg_path_for cacerts),g" \
		"$PLAN_CONTEXT/cacert-path.patch" |
		patch -p1 --backup

	if [[ ! -f "/bin/rm" ]]; then
		hab pkg binlink core/coreutils rm --dest /bin
		BINLINKED_RM=true
	fi
}

do_prepare() {
	_common_prepare
	patch -p1 <"$PLAN_CONTEXT/hab-ssl-cert-file.patch"


	export CROSS_SSL_ARCH="${native_target}"
	PERL=$(pkg_path_for core/build-tools-perl)/bin/perl
	export PERL
	build_line "Setting PERL=${PERL}"
}

do_build() {
	"$(pkg_path_for core/build-tools-perl)"/bin/perl ./Configure \
		--prefix="${pkg_prefix}" \
		--openssldir=ssl \
		enable-fips

	make -j"$(nproc)"
	cp -v $(pkg_path_for core/openssl-stage1)/ssl/fipsmodule.cnf ./providers/
	cp -v $(pkg_path_for core/openssl-stage1)/lib64/ossl-modules/fips.so ./providers/

}

do_check() {
	make tests
}

do_install() {
	do_default_install
	cp $CACHE_PATH/LICENSE.txt "$pkg_prefix"

	# Modify openssl.cnf for FIPS configuration
	sed -i "s|# .include fipsmodule.cnf|.include ${pkg_prefix}/ssl/fipsmodule.cnf|g" "$pkg_prefix/ssl/openssl.cnf"
	sed -i 's|# fips = fips_sect|fips = fips_sect|g' "$pkg_prefix/ssl/openssl.cnf"
	sed -i 's|# activate = 1|activate = 1|g' "$pkg_prefix/ssl/openssl.cnf"

	# Add alg_section after providers = provider_sect in [openssl_init] section
    sed -i '/providers = provider_sect/a alg_section = algorithm_sect' "$pkg_prefix/ssl/openssl.cnf"

	# Add [fips_sect] section after activate = 1
	sed -i '/activate = 1/a\\n[fips_sect]' "$pkg_prefix/ssl/openssl.cnf"

	# Add [algorithm_sect] section after fips = fips_sect with configuration
    sed -i '/fips = fips_sect/a\\n[algorithm_sect]\ndefault_properties = fips=yes' "$pkg_prefix/ssl/openssl.cnf"

	# Remove dependency on Perl at runtime
	rm -rfv "$pkg_prefix/ssl/misc" "$pkg_prefix/bin/c_rehash"
}
