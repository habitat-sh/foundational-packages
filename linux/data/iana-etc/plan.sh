pkg_name="iana-etc"
pkg_origin="core"
pkg_version="20250123"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
The iana-etc package provides the Unix/Linux /etc/services and /etc/protocols \
files.\
"
pkg_upstream_url="http://sethwklein.net/iana-etc"
pkg_license=('MIT')
pkg_source="https://github.com/Mic92/${pkg_name}/releases/download/${pkg_version}/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="93da9dd2962da27b72def08f732eb09dc63bd7fcba4a35973ad653e24d32fdfe"
pkg_deps=()

do_prepare() {
	set_runtime_env "HAB_ETC_SERVICES" "${pkg_prefix}/etc/services"
	set_runtime_env "HAB_ETC_PROTOCOLS" "${pkg_prefix}/etc/protocols"
}

do_build() {
	return 0
}

do_install() {
	mkdir -v "${pkg_prefix}"/etc
	cp services protocols "${pkg_prefix}"/etc
}
