#!/usr/bin/env bash
# A28 - Kumi shell (part of the rice: sway binds, bar, lock, MPRIS media).
# Binary mode installs the A28 prebuilt release (kumi, kumi-lockscreen, kumizo)
# built by .github/workflows/binaries.yml; source mode compiles the vendored
# source (dotfiles/share/shell/kumi) with dotfiles/share/shell/build.
# Mode: ID86_SHELL=binary|source|skip (default: binary, falls back to source).
# Binaries land in ~/.local/bin (absolute paths used by sway).
set -euo pipefail

MODE="${ID86_SHELL:-binary}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

DEST="${ID86_BIN_DIR:-$HOME/.local/bin}"
BINS=(kumi kumizo kumi-lockscreen)
SRC="${SHELL_SRC:-$HOME/.local/share/shell/kumi}"
STAMP="$(dirname "$SRC")/.needs-build"
BUILDER="$SCRIPT_DIR/../dotfiles/share/shell/build"

case "$MODE" in
    binary|source|skip) ;;
    *)
        echo "    (!) unknown ID86_SHELL=$MODE (binary|source|skip), using binary" >&2
        MODE=binary
        ;;
esac
if [[ "$MODE" == skip ]]; then
    echo "    (-) shell skipped (ID86_SHELL=skip)"
    exit 0
fi

check_bins() {
    local b
    for b in "${BINS[@]}"; do
        [[ -x "$DEST/$b" ]] || return 1
    done
}

if check_bins && [[ ! -e "$STAMP" ]]; then
    echo "    shell already present, skipping"
    exit 0
fi

install_binary() {
    local tmp
    tmp=$(mktemp -d)
    if a28_fetch_bin kumi "$tmp"; then
        mkdir -p "$DEST"
        install -m 755 "$tmp/kumi" "$tmp/kumi-lockscreen" "$tmp/kumizo" "$DEST/"
        rm -rf "$tmp"
        check_bins
        return
    fi
    rm -rf "$tmp"
    return 1
}

install_from_source() {
    if [[ "$ID86_DISTRO" == debian ]]; then
        # Shell build deps (gpui/wayland/pam); x11 is separate on trixie:
        # libxkbcommon-x11-dev is no longer in libxkbcommon-dev.
        pkg_deb build-essential pkg-config libasound2-dev \
            libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev \
            libfontconfig1-dev libpam0g-dev
    fi

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

if [[ "$MODE" == binary ]]; then
    echo "==> Installing A28 shell (prebuilt, $A28_BIN_TAG)..."
    if install_binary; then
        if [[ "$ID86_DISTRO" == debian ]]; then
            # Runtime libraries only: binary mode must not pull cargo or -dev.
            pkg_deb libasound2 libxkbcommon0 libxkbcommon-x11-0 \
                libwayland-client0 libfontconfig1 libpam0g libvulkan1
        fi
        exit 0
    fi
    echo "    [!] prebuilt shell unavailable, falling back to a source build"
fi

if install_from_source; then
    exit 0
fi

echo "[!] shell install impossible: cargo and/or native deps missing" >&2
echo "    Arch  : sudo pacman -S --needed rust pkgconf wayland libxkbcommon libxkbcommon-x11 fontconfig alsa-lib pam" >&2
echo "    Debian: build-essential pkg-config libasound2-dev libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev libfontconfig1-dev libpam0g-dev" >&2
exit 1
