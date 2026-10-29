#!/usr/bin/env bash
# A28 - shared module library: distro + package install.
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

# ---------------------------------------------------------------------------
# Prebuilt binaries (published by .github/workflows/binaries.yml).
# A28_BIN_TAG pins another release, A28_BIN_BASE overrides the whole URL
# (mirror, local tests: A28_BIN_BASE=file:///tmp/release).
# ---------------------------------------------------------------------------
A28_BIN_TAG="${A28_BIN_TAG:-binaries-latest}"
A28_BIN_BASE="${A28_BIN_BASE:-https://github.com/noobmaisfier/A28/releases/download/$A28_BIN_TAG}"

a28_arch() {
    case "$(uname -m)" in
        x86_64|amd64) printf %s x86_64 ;;
        aarch64|arm64) printf %s aarch64 ;;
        *)
            echo "    (!) no prebuilt binaries for $(uname -m)" >&2
            return 1
            ;;
    esac
}

# a28_fetch_bin <name> <tmpdir>: download, verify (SHA256SUMS) and extract
# the tarball into <tmpdir>. Returns non-zero if unavailable or corrupt.
a28_fetch_bin() {
    local name=$1 tmp=$2 arch asset want got
    arch=$(a28_arch) || return 1
    asset="${name}-linux-${arch}.tar.gz"
    mkdir -p "$tmp"

    if ! curl -fsSL --retry 3 --connect-timeout 10 -o "$tmp/$asset" "$A28_BIN_BASE/$asset"; then
        echo "    (!) $asset unavailable ($A28_BIN_BASE)" >&2
        return 1
    fi

    if curl -fsSL --retry 3 --connect-timeout 10 -o "$tmp/SHA256SUMS" "$A28_BIN_BASE/SHA256SUMS"; then
        want=$(awk -v f="$asset" '$2 == f || $2 == "./" f { print $1; exit }' "$tmp/SHA256SUMS")
        if [[ -z "$want" ]]; then
            echo "    (!) $asset missing from SHA256SUMS, refusing it" >&2
            return 1
        fi
        got=$(sha256sum "$tmp/$asset" | awk '{ print $1 }')
        if [[ "$got" != "$want" ]]; then
            echo "    (!) checksum mismatch for $asset" >&2
            return 1
        fi
    else
        # A release without checksums is a bug, not a reason to fall back
        # silently: say it out loud so the pipeline gets fixed.
        echo "    (!) SHA256SUMS unavailable, extracting $asset unverified" >&2
    fi

    tar -xzf "$tmp/$asset" -C "$tmp"
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
