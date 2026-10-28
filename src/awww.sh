#!/usr/bin/env bash
# A28 - awww wallpaper: package on Arch, git build on Debian
# (not on crates.io, no upstream binary; https://codeberg.org/LGFae/awww).
# We build the stable TAG, not main: main's lockfile drifted (rustix
# unsafe) while the code did not follow -> main no longer compiles.
# Binaries go into ~/.local/bin (on sway's PATH, unlike
# ~/.cargo/bin) via symlinks.
set -euo pipefail

AWWW_TAG="${AWWW_TAG:-v0.12.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

if [[ "$ID86_DISTRO" == debian ]]; then
    ensure_cargo || exit 1
    # awww build deps (upstream README: system lz4 + dav1d, wayland-client
    # + XML protocols found via pkg-config).
    pkg_deb pkg-config liblz4-dev libdav1d-dev libwayland-dev wayland-protocols
    if ! command -v awww-daemon >/dev/null; then
        echo "==> Building awww $AWWW_TAG from git..."
        tmpdir=$(mktemp -d)
        trap 'rm -rf "$tmpdir"' EXIT
        git clone --depth 1 --branch "$AWWW_TAG" https://codeberg.org/LGFae/awww "$tmpdir/awww" || exit 1
        # Workspace (client + daemon): install per member, not --path .
        (cd "$tmpdir/awww" && cargo install --locked --path ./client && cargo install --locked --path ./daemon) || exit 1
        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.cargo/bin/awww" "$HOME/.local/bin/awww"
        ln -sf "$HOME/.cargo/bin/awww-daemon" "$HOME/.local/bin/awww-daemon"
    else
        echo "    awww already present"
    fi
else
    sudo pacman -S --needed --noconfirm awww
fi

echo "==> awww installed"
