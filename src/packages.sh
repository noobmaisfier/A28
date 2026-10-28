#!/usr/bin/env bash
# id-86 - rice packages (Arch). The personal part (apps, dev toolchain) is in me.sh.

echo "==> Installing rice packages (Arch)..."

sudo pacman -Syu --needed --noconfirm base-devel \
    swayidle \
    foot vim neovim git zsh yazi \
    fzf bat zoxide jq ripgrep poppler file eza fd tree htop \
    noto-fonts-emoji noto-fonts noto-fonts-cjk noto-fonts-extra ttf-liberation \
    ttf-dejavu ttf-roboto ttf-jetbrains-mono ttf-fira-code ttf-hack \
    adobe-source-code-pro-fonts adobe-source-sans-fonts \
    grim slurp wlsunset brightnessctl \
    chafa bash-completion wl-clipboard unzip bc \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-user-dirs \
    nwg-look sassc just resvg rtkit \
    thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman \
    gvfs gvfs-mtp tumbler ffmpegthumbnailer pavucontrol \
    file-roller gthumb \
    fontconfig

# Building the shell (src/shell.sh): rust + native deps.
# The shell is a GPU/wayland/pam binary, not a rice package.
echo "==> Installing shell build dependencies (Arch)..."
sudo pacman -S --needed --noconfirm \
    rust pkgconf wayland libxkbcommon libxkbcommon-x11 \
    fontconfig alsa-lib pam

echo "==> Rice packages installed"
