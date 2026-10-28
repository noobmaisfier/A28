#!/usr/bin/env bash
# A28 - font improvement, system part (davgar99/arch-linux-font-improvement-guide).
# The user rendering (fonts.conf + conf.d) is versioned in dotfiles/fontconfig/
# and copied by dotfiles.sh; the font packages are in packages(_debian).sh.
# Here: presets, freetype, stem darkening, cache. Wayland: no X11 step.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

echo "==> Linking fontconfig presets..."
for conf in 10-sub-pixel-rgb.conf 10-hinting-slight.conf 11-lcdfilter-default.conf 70-no-bitmaps-except-emoji.conf; do
    sudo ln -sf "/usr/share/fontconfig/conf.avail/$conf" /etc/fonts/conf.d/
done

echo "==> Setting freetype interpreter v40..."
if grep -q '^#*export FREETYPE_PROPERTIES="truetype:interpreter-version=40"' /etc/profile.d/freetype2.sh 2>/dev/null; then
    sudo sed -i 's/^#*export FREETYPE_PROPERTIES=.*/export FREETYPE_PROPERTIES="truetype:interpreter-version=40"/' /etc/profile.d/freetype2.sh
elif [[ ! -f /etc/profile.d/freetype2.sh ]]; then
    # Debian: the freetype package does not ship this file, so we create it.
    echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40"' | sudo tee /etc/profile.d/freetype2.sh > /dev/null
else
    echo "    (!) /etc/profile.d/freetype2.sh unexpected, check manually"
fi

echo "==> Enabling stem darkening (low-DPI)..."
if ! grep -q 'no-stem-darkening' /etc/environment 2>/dev/null; then
    echo 'FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"' | sudo tee -a /etc/environment > /dev/null
else
    echo "    stem darkening already present"
fi

fc-cache -f > /dev/null
echo "==> Font system complete (restart open apps)"
