#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
    printf 'This installer supports Arch Linux only.\n' >&2
    exit 1
fi

if (( EUID == 0 )); then
    printf 'Run this script as a regular user; it uses sudo only when needed.\n' >&2
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    printf 'sudo is required to install packages and update the SDDM theme.\n' >&2
    exit 1
fi

sudo pacman -S --needed git base-devel

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

if ! command -v yay >/dev/null 2>&1; then
    git clone https://aur.archlinux.org/yay.git "$work_dir/yay"
    (
        cd "$work_dir/yay"
        makepkg -si
    )
fi

yay -S --needed sddm-theme-sugar-candy-git

theme_dir=/usr/share/sddm/themes/Sugar-Candy
if ! sudo test -d "$theme_dir"; then
    printf 'Sugar Candy was installed, but its theme directory was not found: %s\n' "$theme_dir" >&2
    exit 1
fi

config=/etc/sddm.conf
updated_config="$work_dir/sddm.conf"

if sudo test -f "$config"; then
    sudo cat "$config" > "$updated_config"
else
    : > "$updated_config"
fi

awk '
BEGIN {
    in_theme = 0
    found_theme = 0
    set_current = 0
}
{
    if ($0 ~ /^[[:space:]]*\[[^]]+\][[:space:]]*$/) {
        if (in_theme && !set_current) {
            print "Current=Sugar-Candy"
            set_current = 1
        }
        in_theme = (tolower($0) ~ /^[[:space:]]*\[[[:space:]]*theme[[:space:]]*\][[:space:]]*$/)
        if (in_theme) {
            found_theme = 1
            set_current = 0
        }
    }

    if (in_theme && tolower($0) ~ /^[[:space:]]*current[[:space:]]*=/) {
        if (!set_current) {
            print "Current=Sugar-Candy"
            set_current = 1
        }
        next
    }

    print
}
END {
    if (in_theme && !set_current)
        print "Current=Sugar-Candy"
    if (!found_theme)
        print "\n[Theme]\nCurrent=Sugar-Candy"
}
' "$updated_config" > "$updated_config.new"

if sudo test -f "$config"; then
    backup="${config}.bak.$(date +%Y%m%d%H%M%S)"
    sudo cp -a "$config" "$backup"
    printf 'Backed up the existing SDDM config to %s\n' "$backup"
fi

sudo install -D -m 0644 "$updated_config.new" "$config"
printf 'Sugar Candy is set as the SDDM theme. Log out or reboot to see it.\n'
