#!/usr/bin/env bash
# id-86 - GTK themes for the 7 variants (default: mocha).
# Luv icons + Bibata Modern cursors (Amber/Ice/Classic): installed manually
# (~/.icons, ~/.themes), see README.
# - light      -> flexoki (kepano/flexoki, gtk/, clone sparse)
# - mocha      -> catppuccin-mocha-pink (prebuilt v1.0.3, no build)
# - nord       -> Nordic (EliverLara/Nordic)
# - tokyo      -> Tokyonight (sassc build required, see packages.sh)
# - github     -> ID86-Github (crafted, versioned in dotfiles/gtk-themes/)
# - aurora     -> ID86-Aurora (crafted, versioned in dotfiles/gtk-themes/)
# - gruvbox    -> ID86-Gruvbox (crafted, versioned in dotfiles/gtk-themes/)

echo "==> Configuring Cursor..."
if command -v gsettings >/dev/null && [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
    gsettings set org.gnome.desktop.interface cursor-size 32
else
    echo "    (-) no dbus session, gsettings ignored"
fi
# Persistent for future sessions (the export does not survive the script)
mkdir -p ~/.config/environment.d
printf 'XCURSOR_THEME=Bibata-Modern-Ice\nXCURSOR_SIZE=32\n' > ~/.config/environment.d/10-xcursor.conf

echo "==> Configuring Icons..."
if command -v gsettings >/dev/null && [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Luv'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

echo "==> Configuring GTK Theme (catppuccin mocha)..."

mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=catppuccin-mocha-pink-standard+default
gtk-icon-theme-name=Luv
gtk-font-name=Adwaita Sans 11
gtk-cursor-theme-name=Bibata-Modern-Ice
gtk-cursor-theme-size=32
gtk-application-prefer-dark-theme=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=none
EOF
cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini

gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-pink-standard+default' 2>/dev/null || true
gsettings set org.gnome.desktop.wm.preferences theme 'catppuccin-mocha-pink-standard+default' 2>/dev/null || true

echo "==> Configuring Fonts..."
if command -v gsettings >/dev/null && [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
    gsettings set org.gnome.desktop.interface font-hinting 'slight'
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
    gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans 14'
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono Nerd Font 10'
fi

echo "==> Installing Luv icon theme (https://github.com/Nitrux/luv-icon-theme)..."
if [[ ! -f "$HOME/.icons/Luv/index.theme" ]]; then
    tmpdir=$(mktemp -d)
    git clone --depth 1 https://github.com/Nitrux/luv-icon-theme.git "$tmpdir/luv" || exit 1
    mkdir -p "$HOME/.icons"
    cp -r "$tmpdir/luv/Luv" "$HOME/.icons/Luv"
    rm -rf "$tmpdir"
    gtk-update-icon-cache "$HOME/.icons/Luv" 2>/dev/null || true
else
    echo "    Luv already present"
fi

echo "==> Installing Bibata Modern cursors (GitHub tarballs, no AUR)..."
for variant in Amber Ice Classic; do
    if [[ ! -d "$HOME/.icons/Bibata-Modern-$variant" ]]; then
        tmpdir=$(mktemp -d)
        curl -fsSL -o "$tmpdir/bibata.tar.xz" "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-$variant.tar.xz" || exit 1
        mkdir -p "$HOME/.icons"
        tar -xJf "$tmpdir/bibata.tar.xz" -C "$HOME/.icons" || exit 1
        rm -rf "$tmpdir"
    else
        echo "    Bibata-Modern-$variant already present"
    fi
done

echo "==> Installing Nordic GTK theme (https://github.com/EliverLara/Nordic)..."
echo "    (nord variant: gtk-theme-name=Nordic)"
if [[ ! -f "$HOME/.themes/Nordic/index.theme" ]]; then
    mkdir -p "$HOME/.themes"
    git clone --depth 1 https://github.com/EliverLara/Nordic.git "$HOME/.themes/Nordic" || exit 1
else
    echo "    Nordic already present"
fi

echo "==> Installing flexoki GTK theme (https://github.com/kepano/flexoki, gtk/ directory)..."
echo "    (light variant: gtk-theme-name=flexoki)"
if [[ ! -f "$HOME/.local/share/themes/flexoki/index.theme" ]]; then
    tmpdir=$(mktemp -d)
    git clone --depth 1 --filter=blob:none --sparse https://github.com/kepano/flexoki.git "$tmpdir/flexoki" || exit 1
    (cd "$tmpdir/flexoki" && git sparse-checkout set gtk) || exit 1
    mkdir -p "$HOME/.local/share/themes"
    cp -r "$tmpdir/flexoki/gtk" "$HOME/.local/share/themes/flexoki"
    rm -rf "$tmpdir"
else
    echo "    flexoki already present"
fi

echo "==> Installing catppuccin-mocha-pink GTK (prebuilt v1.0.3, https://github.com/catppuccin/gtk/releases)..."
echo "    (mocha variant, install.py broken on recent python -> direct zip)"
if [[ ! -d "$HOME/.local/share/themes/catppuccin-mocha-pink-standard+default" ]]; then
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/mocha.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-pink-standard+default.zip" || exit 1
    mkdir -p "$HOME/.local/share/themes"
    unzip -q -o "$tmpdir/mocha.zip" -d "$HOME/.local/share/themes" || exit 1
    rm -rf "$tmpdir"
else
    echo "    catppuccin-mocha-pink already present"
fi

echo "==> Installing Tokyonight GTK (https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme)..."
echo "    (tokyo-night variant, sassc build required)"
if [[ ! -d "$HOME/.themes/Tokyonight-Dark" ]]; then
    command -v sassc >/dev/null || { echo "    (!) install sassc first: sudo pacman -S --needed sassc"; exit 1; }
    tmpdir=$(mktemp -d)
    git clone --depth 1 https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme "$tmpdir/tokyonight" || exit 1
    "$tmpdir/tokyonight/themes/install.sh" -t default -c dark || exit 1
    rm -rf "$tmpdir"
else
    echo "    Tokyonight already present"
fi

echo "==> Theme configuration complete (mocha)"
