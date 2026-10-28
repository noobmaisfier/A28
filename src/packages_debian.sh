#!/usr/bin/env bash
# A28 - rice packages (Debian trixie+).
# Tolerant apt (see lib.sh): names vary across Debian versions.
# Not ported: nwg-look (no package), awww (git build, see awww.sh).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

echo "==> Installing rice packages (Debian)..."
sudo apt-get update
pkg_deb build-essential curl pkg-config git \
    swayidle \
    foot vim neovim zsh yazi \
    fzf bat zoxide jq ripgrep file eza fd-find tree htop \
    chafa bash-completion wl-clipboard grim slurp wlsunset brightnessctl \
    unzip bc poppler-utils resvg rtkit \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-user-dirs \
    sassc \
    thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman \
    gvfs tumbler ffmpegthumbnailer pavucontrol file-roller gthumb \
    fontconfig \
    fonts-noto fonts-noto-cjk fonts-noto-color-emoji fonts-noto-extra \
    fonts-liberation fonts-dejavu fonts-roboto fonts-jetbrains-mono \
    fonts-firacode fonts-hack \
    fonts-adobe-source-code-pro fonts-adobe-source-sans-pro

echo "==> Binary shims (different Debian names)..."
mkdir -p "$HOME/.local/bin"
if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi
if ! command -v fd >/dev/null && command -v fdfind >/dev/null; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

echo "==> Rice packages installed"
