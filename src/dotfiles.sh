#!/usr/bin/env bash
# id-86 - dotfiles installation from the versioned files.
# Target: Arch Linux + systemd + sway (mocha by default).
set -euo pipefail
shopt -s nullglob

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../dotfiles" && pwd)"
BACKUP_DIR="$HOME/.backup-id-86/$(date +%Y%m%d%H%M%S)"

echo "==> Backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Root files in $HOME
for dotfile in .bashrc .vimrc .zshrc .aliases.sh; do
    if [[ -f "$DOTFILES_DIR/$dotfile" ]]; then
        if [[ -e "$HOME/$dotfile" ]]; then
            cp -a "$HOME/$dotfile" "$BACKUP_DIR/"
        fi
        cp "$DOTFILES_DIR/$dotfile" "$HOME/$dotfile"
    fi
done

# Full .vim directory (faithful backup, no merge)
if [[ -d "$DOTFILES_DIR/.vim" ]]; then
    if [[ -e "$HOME/.vim" ]]; then
        rm -rf "$BACKUP_DIR/.vim"
        cp -a "$HOME/.vim" "$BACKUP_DIR/.vim"
    fi
    mkdir -p "$HOME/.vim"
    cp -r "$DOTFILES_DIR/.vim/"* "$HOME/.vim/"
fi

# ~/.config configs (nvim optional: see ID86_NVIM in setup.sh)
config_items=(fontconfig foot sway yazi fastfetch gtk-3.0 gtk-4.0)
[[ "${ID86_NVIM:-0}" == 1 ]] && config_items+=(nvim)
for item in "${config_items[@]}"; do
    target="$HOME/.config/$item"
    if [[ -e "$target" || -L "$target" ]]; then
        rm -rf "$BACKUP_DIR/$item"
        cp -a "$target" "$BACKUP_DIR/$item"
        rm -rf "$target"
    fi
    if [[ -e "$DOTFILES_DIR/$item" ]]; then
        mkdir -p "$HOME/.config"
        cp -r "$DOTFILES_DIR/$item" "$target"
    fi
done

# mimeapps (with backup)
if [[ -f "$DOTFILES_DIR/mimeapps.list" ]]; then
    if [[ -e "$HOME/.config/mimeapps.list" ]]; then
        cp -a "$HOME/.config/mimeapps.list" "$BACKUP_DIR/"
    fi
    cp "$DOTFILES_DIR/mimeapps.list" "$HOME/.config/mimeapps.list"
fi

if [[ -d "$DOTFILES_DIR/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
    # old change-theme/ directory (6 set-*.sh) -> replaced by the single binary
    rm -rf "$HOME/.local/bin/change-theme"
    cp -r "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
fi

# ~/.local/share/shell: vendored shell source + build helper. Replace the
# whole directory so the code is always the version from this repo; back up
# the previous one first (excluding build artifacts).
if [[ -d "$DOTFILES_DIR/share/shell" ]]; then
    shell_hash() {
        (cd "$1" && find . -path ./target -prune -o -path ./.git -prune -o \
            -type f ! -name .source-hash ! -name .needs-build -print0 \
            | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum | cut -d' ' -f1)
    }

    shell_target="$HOME/.local/share/shell"
    old_hash=""
    installed_hash=""
    [[ -f "$shell_target/.source-hash" ]] && old_hash="$(<"$shell_target/.source-hash")"
    [[ -e "$shell_target" ]] && installed_hash="$(shell_hash "$shell_target")"

    if [[ -e "$shell_target" ]]; then
        rm -rf "$BACKUP_DIR/share-shell"
        mkdir -p "$BACKUP_DIR/share-shell"
        (cd "$shell_target" && tar --exclude=.git --exclude=target -cf - .) \
            | (cd "$BACKUP_DIR/share-shell" && tar xf -)
    fi
    rm -rf "$shell_target"
    mkdir -p "$shell_target"
    # Copy the source, never build artifacts (.git/target).
    (cd "$DOTFILES_DIR/share/shell" && tar --exclude=.git --exclude=target -cf - .) \
        | (cd "$shell_target" && tar xf -)

    new_hash="$(shell_hash "$shell_target")"
    printf '%s\n' "$new_hash" > "$shell_target/.source-hash"
    # Rebuild if the vendored code changed or if the user had edited the
    # installed copy (which was just replaced and backed up).
    if [[ "$installed_hash" != "$old_hash" || "$new_hash" != "$old_hash" ]]; then
        touch "$shell_target/.needs-build"
    fi
fi

# systemd user units (awww slideshow)
if [[ -d "$DOTFILES_DIR/systemd/user" ]]; then
    mkdir -p "$HOME/.config/systemd/user"
    cp "$DOTFILES_DIR/systemd/user/"* "$HOME/.config/systemd/user/"
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now awww-cycle.timer 2>/dev/null || true
    # Fallback outside a session (no user bus): enable via direct symlink
    mkdir -p "$HOME/.config/systemd/user/timers.target.wants"
    ln -sf "../awww-cycle.timer" "$HOME/.config/systemd/user/timers.target.wants/awww-cycle.timer"
fi

if [[ -d "$DOTFILES_DIR/.wallpaper" ]]; then
    mkdir -p "$HOME/.wallpaper"
    cp -r "$DOTFILES_DIR/.wallpaper/"* "$HOME/.wallpaper/"
fi

# Crafted GTK themes (D86-*, versioned) -> ~/.themes
if [[ -d "$DOTFILES_DIR/gtk-themes" ]]; then
    mkdir -p "$HOME/.themes"
    cp -a "$DOTFILES_DIR/gtk-themes/"* "$HOME/.themes/"
fi

echo "==> Dotfiles installed (backup at $BACKUP_DIR)"
echo "==> Remember: ./postinstall.sh (vim plugins, reloads, XDG dirs)"
