#!/usr/bin/env bash
# id-86 - shared module library: distro + package install.
# ID86_DISTRO: arch | debian (auto via /etc/os-release, can be forced manually).
# apt is intentionally tolerant: an unknown name does not cancel the rest
# (package names vary across Debian versions).

if [[ -z "${ID86_DISTRO:-}" ]]; then
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID_LIKE:-$ID}" in
            *arch*) ID86_DISTRO=arch ;;
            *debian*|*ubuntu*) ID86_DISTRO=debian ;;
            *) ID86_DISTRO=unknown ;;
        esac
    else
        ID86_DISTRO=unknown
    fi
fi
export ID86_DISTRO

# cargo on PATH (rustup, Debian): each module runs in its own process,
# so each calls ensure_cargo for itself.
ensure_cargo() {
    export PATH="$HOME/.cargo/bin:$PATH"
    if ! command -v cargo >/dev/null; then
        echo "    (!) cargo missing, run src/rust.sh first"
        return 1
    fi
}

# apt in a tolerant loop (only use after an apt-get update,
# done by packages_debian.sh, the first module in the flow).
pkg_deb() {
    local p
    for p in "$@"; do
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$p" \
            || echo "    [!] $p unavailable, skipping"
    done
}
