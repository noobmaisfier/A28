#!/usr/bin/env bash
# id-86 - rice installation (Arch + Debian).
# Pure, portable rice: ./setup.sh
# Rice + personal apps: ./me.sh
# Recommended prerequisite: FRESH install.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/src/lib.sh"

# Rice Neovim config: optional. ID86_NVIM=1|0 to script it without prompting.
choose_nvim() {
    # Already forced by the environment: do not prompt.
    if [[ -n "${ID86_NVIM:-}" ]]; then
        return
    fi

    if [[ -f "$HOME/.config/nvim/init.lua" ]]; then
        ID86_NVIM=0   # existing config: keep it by default
    else
        ID86_NVIM=1   # fresh install: offer the rice one
    fi

    # No terminal (curl | bash, CI): keep the default.
    [[ -t 0 && -r /dev/tty ]] || { export ID86_NVIM; return; }

    local answer=""
    if [[ -f "$HOME/.config/nvim/init.lua" ]]; then
        read -r -p "Existing nvim config. Replace it with the rice one? [y/N] " answer </dev/tty || true
        [[ "$answer" =~ ^[yY]$ ]] && ID86_NVIM=1
    else
        read -r -p "Install the rice Neovim config? [Y/n] " answer </dev/tty || true
        [[ "$answer" =~ ^[nN]$ ]] && ID86_NVIM=0
    fi
    export ID86_NVIM
}

# Compositor: swayfs (rice fork) is optional. ID86_SWAYFS=1|0 to script it.
swayfs_installed() {
    if command -v pacman >/dev/null 2>&1 && pacman -Qq swayfs >/dev/null 2>&1; then
        return 0
    fi
    sway --version 2>/dev/null | grep -qi "swayfs"
}

choose_swayfs() {
    if [[ -n "${ID86_SWAYFS:-}" ]]; then
        return
    fi

    if swayfs_installed; then
        ID86_SWAYFS=0
        echo "    swayfs already installed, keeping it."
    elif command -v sway >/dev/null 2>&1; then
        ID86_SWAYFS=0   # another compositor: do not replace by default
    else
        ID86_SWAYFS=1   # clean machine: offer swayfs
    fi

    [[ -t 0 && -r /dev/tty ]] || { export ID86_SWAYFS; return; }

    local answer=""
    if swayfs_installed; then
        :
    elif command -v sway >/dev/null 2>&1; then
        read -r -p "A sway compositor is already installed. Install swayfs instead? [y/N] " answer </dev/tty || true
        [[ "$answer" =~ ^[yY]$ ]] && ID86_SWAYFS=1
    else
        read -r -p "Install swayfs (sway fork with effects)? [Y/n] " answer </dev/tty || true
        [[ "$answer" =~ ^[nN]$ ]] && ID86_SWAYFS=0
    fi
    export ID86_SWAYFS
}

choose_nvim
choose_swayfs

echo "==> id-86 rice (distro: $ID86_DISTRO)"

run_module() {
    local module=$1
    local script="$SCRIPT_DIR/src/${module}.sh"

    if [[ -f "$script" ]]; then
        echo "==> Running $module..."
        bash "$script" || { echo "Error: module $module FAILED"; exit 1; }
        echo ""
    else
        echo "Error: Module $module not found"
        exit 1
    fi
}

install_iwd() {
    echo "==> Installing iwd (wireless daemon)..."
    if [[ "$ID86_DISTRO" == debian ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iwd \
            || { echo "    [!] iwd unavailable, skipping"; return 0; }
    else
        sudo pacman -S --needed --noconfirm iwd
    fi
    sudo systemctl enable --now iwd
    echo "==> iwd installed and service enabled"
}

if [[ "$ID86_DISTRO" == debian ]]; then
    run_module packages_debian
else
    run_module packages
fi
run_module aur
run_module rust
run_module node
run_module swayfs
run_module awww
run_module dotfiles
run_module shell
run_module zsh
run_module fonts
run_module herdr
run_module theme
run_module bluetooth
install_iwd

echo "==> Running postinstall..."
bash "$SCRIPT_DIR/postinstall.sh" || echo "[!] postinstall incomplete, re-run ./postinstall.sh in a sway session"

echo ""
echo "==> Setup complete!"
