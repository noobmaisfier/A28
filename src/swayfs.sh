#!/usr/bin/env bash
# A28 - sway compositor (swayfs fork, effects + extras).
# Via the upstream installer (Arch: PKGBUILD + makepkg; Debian: meson
# build + pinned wlroots/scenefx, long). Skip if swayfs is already in place.
# Branch: SWAYFS_BRANCH (default main, passed to the installer).
set -euo pipefail

if [[ "${ID86_SWAYFS:-1}" != 1 ]]; then
    echo "    (-) swayfs not requested (ID86_SWAYFS=$ID86_SWAYFS), skipping"
    exit 0
fi

if sway --version 2>/dev/null | grep -qi "swayfs" || \
   { command -v pacman >/dev/null 2>&1 && pacman -Qq swayfs >/dev/null 2>&1; }; then
    echo "    swayfs already present ($(sway --version))"
    exit 0
fi

echo "==> Installing swayfs (fork sway)..."
export SWAYFS_BRANCH="${SWAYFS_BRANCH:-main}"
curl -fsSL "https://raw.githubusercontent.com/noobmaisfier/swayfs/refs/heads/$SWAYFS_BRANCH/packaging/aur/install.sh" | sh
