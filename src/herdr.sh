#!/usr/bin/env bash
# id-86 - herdr: installs via the official script (binary in ~/.local/bin).
set -euo pipefail

echo "==> Installing herdr..."
if command -v herdr &> /dev/null; then
    echo "    herdr already present"
else
    curl -fsSL https://herdr.dev/install.sh | sh
fi

echo "==> herdr installed"
