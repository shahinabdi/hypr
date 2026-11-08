#!/usr/bin/env bash
set -euo pipefail

if ! command -v gsettings >/dev/null 2>&1; then
    printf 'gsettings is required to apply the desktop dark color scheme.\n' >&2
    exit 1
fi

schema=org.gnome.desktop.interface
if ! gsettings list-schemas | grep -Fxq "$schema"; then
    printf 'Required GSettings schema is unavailable: %s\n' "$schema" >&2
    exit 1
fi

gsettings set "$schema" color-scheme 'prefer-dark'
gsettings set "$schema" gtk-theme 'Adwaita'
gsettings set "$schema" icon-theme 'Papirus-Dark'

printf 'Dark appearance applied: Adwaita, Papirus-Dark icons, and prefer-dark color scheme.\n'
printf 'Restart open GTK applications, including Thunar, to update their appearance.\n'
