#!/usr/bin/env bash
# A28 - awww wallpaper: package on Arch, prebuilt release or git build on
# Debian (not on crates.io, no upstream binary; https://codeberg.org/LGFae/awww).
# Binary mode downloads the A28 release built by .github/workflows/binaries.yml;
# source mode builds the stable TAG, not main: main's lockfile drifted (rustix
# unsafe) while the code did not follow -> main no longer compiles.
# Mode: ID86_AWWW=binary|source|skip (default: binary, falls back to source).
# Binaries go into ~/.local/bin (on sway's PATH, unlike ~/.cargo/bin).
set -euo pipefail

AWWW_TAG="${AWWW_TAG:-v0.12.1}"
MODE="${ID86_AWWW:-binary}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

case "$MODE" in
    binary|source|skip) ;;
    *)
        echo "    (!) unknown ID86_AWWW=$MODE (binary|source|skip), using binary" >&2
        MODE=binary
        ;;
esac
if [[ "$MODE" == skip ]]; then
    echo "    (-) awww skipped (ID86_AWWW=skip)"
    exit 0
fi

if command -v awww-daemon >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/awww-daemon" ]]; then
    echo "    awww already present"
    exit 0
fi

install_binary() {
    local tmp
    tmp=$(mktemp -d)
    if a28_fetch_bin awww "$tmp"; then
        mkdir -p "$HOME/.local/bin"
        install -m 755 "$tmp/awww" "$tmp/awww-daemon" "$HOME/.local/bin/"
        rm -rf "$tmp"
        return 0
    fi
    rm -rf "$tmp"
    return 1
}

if [[ "$ID86_DISTRO" == debian ]]; then
    built=0
    if [[ "$MODE" == binary ]]; then
        echo "==> Installing awww (prebuilt, $A28_BIN_TAG)..."
        if install_binary; then
            # Runtime libraries only: binary mode must not pull cargo or -dev.
            pkg_deb liblz4-1 libdav1d7 libwayland-client0
            built=1
        else
            echo "    [!] prebuilt awww unavailable, falling back to a source build"
        fi
    fi

    if [[ "$built" == 0 ]]; then
        ensure_cargo || exit 1
        # awww build deps (upstream README: system lz4 + dav1d, wayland-client
        # + XML protocols found via pkg-config).
        pkg_deb pkg-config liblz4-dev libdav1d-dev libwayland-dev wayland-protocols
        echo "==> Building awww $AWWW_TAG from git..."
        tmpdir=$(mktemp -d)
        trap 'rm -rf "$tmpdir"' EXIT
        git clone --depth 1 --branch "$AWWW_TAG" https://codeberg.org/LGFae/awww "$tmpdir/awww" || exit 1
        # Workspace (client + daemon): install per member, not --path .
        (cd "$tmpdir/awww" && cargo install --locked --path ./client && cargo install --locked --path ./daemon) || exit 1
        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.cargo/bin/awww" "$HOME/.local/bin/awww"
        ln -sf "$HOME/.cargo/bin/awww-daemon" "$HOME/.local/bin/awww-daemon"
    fi
else
    sudo pacman -S --needed --noconfirm awww
fi

echo "==> awww installed"
