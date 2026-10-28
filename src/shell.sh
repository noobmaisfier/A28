#!/usr/bin/env bash
# id-86 - Kumi shell (part of the rice: sway binds, bar, lock, MPRIS media).
# Compiled only: the Kumi source is vendored in dotfiles/share/shell/kumi,
# installed in ~/.local/share/shell/kumi and built by ~/.local/share/shell/build.
# The kumizo CLI and SDK come from crates.io. Binaries land in ~/.local/bin
# (absolute paths used by sway).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

DEST="${ID86_BIN_DIR:-$HOME/.local/bin}"
BINS=(kumi kumizo kumi-lockscreen)
SRC="${SHELL_SRC:-$HOME/.local/share/shell/kumi}"
STAMP="$(dirname "$SRC")/.needs-build"
BUILDER="$SCRIPT_DIR/../dotfiles/share/shell/build"

echo "==> Installing id-86 shell from source..."

installed=1
for b in "${BINS[@]}"; do
    [[ -x "$DEST/$b" ]] || installed=0
done
if [[ $installed == 1 && -f "$SRC/Cargo.toml" && ! -e "$STAMP" ]]; then
    echo "    shell already present, skipping"
    exit 0
fi

if [[ "$ID86_DISTRO" == debian ]]; then
    # Shell build deps (gpui/wayland/pam); x11 is separate on trixie:
    # libxkbcommon-x11-dev is no longer in libxkbcommon-dev.
    pkg_deb build-essential pkg-config libasound2-dev \
        libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev \
        libfontconfig1-dev libpam0g-dev
fi

check_bins() {
    local b
    for b in "${BINS[@]}"; do
        [[ -x "$DEST/$b" ]] || return 1
    done
}

install_from_source() {
    ensure_cargo || return 1
    if [[ ! -f "$BUILDER" ]]; then
        echo "[!] build helper missing: $BUILDER" >&2
        return 1
    fi
    if [[ ! -f "$SRC/Cargo.toml" ]]; then
        echo "[!] shell source missing: $SRC" >&2
        echo "    run src/dotfiles.sh first" >&2
        return 1
    fi
    SHELL_SRC="$SRC" ID86_PREFIX="$(dirname "$DEST")" bash "$BUILDER" || return 1
    check_bins || return 1
    rm -f "$STAMP"
}

if install_from_source; then
    exit 0
fi

echo "[!] shell install impossible: cargo and/or native deps missing" >&2
echo "    Arch  : sudo pacman -S --needed rust pkgconf wayland libxkbcommon libxkbcommon-x11 fontconfig alsa-lib pam" >&2
echo "    Debian: build-essential pkg-config libasound2-dev libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev libfontconfig1-dev libpam0g-dev" >&2
exit 1
