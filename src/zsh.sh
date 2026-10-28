#!/usr/bin/env bash
# A28 - zsh shell: oh-my-zsh + external plugins (mirrors the current ~/.zshrc).
set -euo pipefail

echo "==> Installing oh-my-zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/omz-install.sh || exit 1
    sh /tmp/omz-install.sh --unattended
    rm -f /tmp/omz-install.sh
fi

echo "==> Installing zsh plugins (custom)..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for plugin in zsh-completions zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
        git clone --depth 1 "https://github.com/zsh-users/$plugin.git" "$ZSH_CUSTOM/plugins/$plugin" || exit 1
    else
        echo "    $plugin already present"
    fi
done

echo "==> zsh setup done (.zshrc installed via --dotfiles)"
