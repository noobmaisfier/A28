#!/usr/bin/env bash
# A28 - post-installation: steps that need an active session
# (they cannot run in a pure headless setup).
# Usage: ./postinstall.sh (preferably from a sway session)
# Steps: [1/4] vim, [2/4] nvim/Mason, [3/4] sway, [4/4] XDG.
set -e

echo "==> [1/4] vim plugins (vim-plug)..."
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
    echo "    vim-plug missing, installing..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# Headless, safe to re-run. Generous timeout (markdown-preview's pnpm hook
# can be slow; broken node = hook ignored).
# Synchronous: waits for the install to finish (otherwise qa can exit too early).
timeout 300 vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall --sync" -c "qa" || \
    echo "    [!] PlugInstall incomplete, re-run: vim +PlugInstall +qall"

echo "==> [2/4] nvim plugins + Mason servers..."
if [[ -f "$HOME/.config/nvim/init.lua" ]]; then
    # Lazy sync installs the plugins pinned in lazy-lock.json.
    timeout 600 nvim --headless "+Lazy! sync" +qa || \
        echo "    [!] Lazy sync incomplete, re-run: nvim +Lazy sync"
    # In headless mode MasonInstall is blocking and exits with an error if a
    # package is invalid. The names are the Mason registry ones (not lspconfig's).
    timeout 1200 nvim --headless \
        "+MasonInstall html-lsp css-lsp tsgo clangd pyright jdtls \
         bash-language-server gopls dockerfile-language-server \
         yaml-language-server json-lsp \
         templ \
         stylua black prettier biome" \
        +qa || echo "    [!] MasonInstall incomplete, re-run: nvim +MasonInstall ..."
else
    echo "    (-) nvim config missing (ID86_NVIM=0), step skipped"
fi

echo "==> [3/4] Reloading sway..."
swaymsg reload || echo "    [!] not in a sway session, manual reload required"

echo "==> [4/4] Standard XDG directories..."
xdg-user-dirs-update || echo "    [!] xdg-user-dirs-update failed"

echo ""
echo "==> Remaining manual steps:"
echo "    - nvim: if Lazy/Mason failed, re-run the commands above"
