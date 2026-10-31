#!/usr/bin/env bash
# A28 - AUR packages (Arch only; skipped on Debian).
# The personal AUR packages (helium, megasync...) are in me.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

if [[ "$ID86_DISTRO" != arch ]]; then
    echo "    (-) no AUR on $ID86_DISTRO, skipping"
    exit 0
fi

echo "==> Checking AUR helper (yay)..."
if ! command -v yay &> /dev/null; then
    echo "yay not found, installing..."
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" || exit 1
    cd "$tmpdir/yay" || exit 1
    makepkg -si --noconfirm
    cd - >/dev/null
fi

echo "==> Installing AUR packages..."
# iwgtk is not in the official repos (network frontend for iwd).
yay -S --needed --noconfirm iwgtk

# ttf-symbola (fonts guide): upstream often down/404, failure tolerated.
yay -S --needed --noconfirm ttf-symbola || echo "==> ttf-symbola unavailable, try again later"

echo "==> AUR packages installed"
