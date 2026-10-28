#!/usr/bin/env bash
# A28 - Rust toolchain: Debian via rustup (apt is too old for
# gpui/kumi and awww); Arch: rust/cargo come from packages.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib.sh"

if [[ "$ID86_DISTRO" != debian ]]; then
    echo "    (-) Arch: no rustup, skipping"
    exit 0
fi

export PATH="$HOME/.cargo/bin:$PATH"
if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
    echo "==> Installing rustup (stable, minimal)..."
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs -o /tmp/rustup-init.sh
    sh /tmp/rustup-init.sh -y --default-toolchain stable --profile minimal
    rm -f /tmp/rustup-init.sh
else
    echo "    cargo already present ($(cargo --version))"
fi
