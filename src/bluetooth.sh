#!/usr/bin/env bash
# id-86 - bluetooth (Arch + Debian, systemd).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

echo "==> Installing bluetooth..."
if [[ "$ID86_DISTRO" == debian ]]; then
    pkg_deb bluez blueman
else
    sudo pacman -S --needed --noconfirm bluez bluez-utils blueman
fi
sudo systemctl enable --now bluetooth
echo "==> Bluetooth installed and enabled"
