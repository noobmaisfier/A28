#!/usr/bin/env bash
# id-86 - LazyDB (personal tool): installs the binary into ~/.local/bin.
# The installer manages its own PATH block in ~/.zshrc (idempotent).
set -euo pipefail

echo "==> Installing LazyDB..."
if command -v lazydb >/dev/null 2>&1 && grep -q ">>> LazyDB installer >>>" "$HOME/.zshrc" 2>/dev/null; then
    echo "    lazydb already present: $(lazydb --version 2>/dev/null || echo 'unknown version')"
else
    curl -fsSL https://lazydb.yelog.org/install.sh | sh
fi
