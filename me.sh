#!/usr/bin/env bash
# A28 - personal part: the rice (setup.sh) + the author's apps and habits.
# Usage: ./me.sh (Arch recommended; Debian: best effort, some
# packages do not exist outside the AUR).
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/setup.sh" || exit 1

# shellcheck disable=SC1091
. "$SCRIPT_DIR/src/lib.sh"

echo "==> A28 personal (distro: $ID86_DISTRO)"

if [[ "$ID86_DISTRO" == debian ]]; then
    pkg_deb telegram-desktop mpv yt-dlp galculator atril golang \
        android-sdk-platform-tools atomicparsley aria2 \
        docker.io docker-compose gh glab
    echo "    (-) helium / megasync / drawio: no simple Debian package, install manually"
else
    sudo pacman -S --needed --noconfirm \
        telegram-desktop atril drawio-desktop galculator \
        android-tools android-udev mpv yt-dlp \
        atomicparsley aria2 python-mutagen python-websockets python-brotli python-xattr python-secretstorage \
        docker docker-compose \
        rust go lazygit just \
        github-cli glab
    yay -S --needed --noconfirm helium-browser-bin megasync ttf-ms-fonts
    # kumizo/kumi: built by setup.sh from the vendored source into
    # ~/.local/bin — no kumizo-bin AUR package.
fi

echo "==> Configuring docker (without autostart)..."
bash "$SCRIPT_DIR/src/docker.sh" || echo "[!] docker incomplete"

echo "==> Installing LazyDB (personal)..."
bash "$SCRIPT_DIR/src/lazydb.sh" || echo "[!] lazydb incomplete"

echo ""
echo "==> me.sh complete!"
