#!/usr/bin/env bash
# A28 - docker (Arch + systemd).
set -euo pipefail

echo "==> Configuring Docker..."
USER_NAME="${SUDO_USER:-$USER}"
sudo usermod -aG docker "$USER_NAME"
# No autostart (lightweight): neither service nor socket enabled.
# Manual start: sudo systemctl start docker
sudo systemctl disable --now docker.service docker.socket 2>/dev/null || true
echo "==> Docker configured (log back in for the docker group)"
