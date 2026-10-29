#!/usr/bin/env bash
# A28 - Node 24 via nvm + pnpm (official methods, user-local,
# Arch + Debian, no sudo). Replaces the distro packages (nodejs/npm/pnpm).
# nvm edits ~/.zshrc on install but dotfiles.sh overwrites it afterwards:
# the durable block is versioned in dotfiles/.zshrc.
set -euo pipefail

export NVM_DIR="$HOME/.nvm"
# nvm's installer aborts when $NVM_DIR exists but is set to anything other than
# its default ($XDG_CONFIG_HOME/nvm when that is set). Creating it first skips
# that check, so the versioned dotfiles/.zshrc (which sources $NVM_DIR) stays valid.
mkdir -p "$NVM_DIR"

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    echo "==> Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
else
    echo "    nvm already present"
fi

set +u # nvm.sh does not like nounset
# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
echo "==> Installing Node 24..."
nvm install 24
nvm alias default 24
nvm use default > /dev/null
set -u

if ! command -v pnpm >/dev/null; then
    echo "==> Installing pnpm..."
    curl -fsSL https://get.pnpm.io | sh -
else
    echo "    pnpm already present ($(pnpm --version))"
fi

echo "==> Linking node/npm/npx/pnpm into ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
for t in node npm npx; do
    p="$(command -v $t)" && ln -sf "$p" "$HOME/.local/bin/$t"
done
if [[ -x "$HOME/.local/share/pnpm/pnpm" ]]; then
    ln -sf "$HOME/.local/share/pnpm/pnpm" "$HOME/.local/bin/pnpm"
elif [[ -x "$HOME/.local/share/pnpm/bin/pnpm" ]]; then
    ln -sf "$HOME/.local/share/pnpm/bin/pnpm" "$HOME/.local/bin/pnpm"
fi

echo "==> node $(node --version), pnpm $($HOME/.local/bin/pnpm --version 2>/dev/null || echo 'reopen the shell')"
