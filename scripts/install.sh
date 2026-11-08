#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /etc/arch-release ]]; then
    printf 'This installer supports Arch Linux only.\n' >&2
    exit 1
fi

if (( EUID == 0 )); then
    printf 'Run this installer as a regular user; it uses sudo when needed.\n' >&2
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    printf 'sudo is required to install packages.\n' >&2
    exit 1
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}

required_paths=(
    Thunar
    gtk-3.0
    hypr
    kitty
    quickshell
    rofi
    scripts
    waybar
    xfce4
    pavucontrol.ini
    wallpapers
)

for path in "${required_paths[@]}"; do
    if [[ ! -e "$repo_root/$path" ]]; then
        printf 'Required configuration path is missing: %s\n' "$repo_root/$path" >&2
        exit 1
    fi
done

packages=(
    bluez
    bluez-utils
    brightnessctl
    cliphist
    curl
    dconf
    exo
    fontconfig
    grim
    gsettings-desktop-schemas
    gtk3
    gtk4
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprpolkitagent
    kitty
    libnotify
    networkmanager
    papirus-icon-theme
    pavucontrol
    pipewire
    pipewire-pulse
    playerctl
    qt6-wayland
    quickshell
    rofi
    slurp
    swaync
    thunar
    ttf-jetbrains-mono-nerd
    unzip
    waybar
    wireplumber
    wl-clipboard
    xdg-desktop-portal-hyprland
)

sudo -v
sudo pacman -S --needed "${packages[@]}"

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

font_archive="$work_dir/Go-Mono.zip"
font_extract_dir="$work_dir/go-mono"
font_dir="$HOME/.local/share/fonts/NerdFonts/GoMono"
curl --fail --location --retry 3 \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Go-Mono.zip \
    --output "$font_archive"
mkdir -p "$font_extract_dir"
unzip -q "$font_archive" -d "$font_extract_dir"

font_count=0
while IFS= read -r -d '' font_file; do
    install -Dm644 "$font_file" "$font_dir/$(basename "$font_file")"
    ((font_count += 1))
done < <(find "$font_extract_dir" -type f -iname '*.ttf' -print0)

if (( font_count == 0 )); then
    printf 'The GoMono Nerd Font archive did not contain any TTF files.\n' >&2
    exit 1
fi

fc-cache --force "$font_dir"

timestamp=$(date +%Y%m%d-%H%M%S)
while IFS= read -r -d '' source_file; do
    relative_path=${source_file#"$repo_root"/}
    target_file="$config_home/$relative_path"
    target_dir=$(dirname -- "$target_file")
    mkdir -p "$target_dir"

    if [[ -e "$target_file" || -L "$target_file" ]]; then
        if [[ -f "$target_file" ]] && cmp -s -- "$source_file" "$target_file"; then
            continue
        fi

        backup_file="${target_file}.bak.${timestamp}"
        if [[ -e "$backup_file" || -L "$backup_file" ]]; then
            printf 'Refusing to overwrite existing backup: %s\n' "$backup_file" >&2
            exit 1
        fi
        mv -- "$target_file" "$backup_file"
        printf 'Backed up %s to %s\n' "$target_file" "$backup_file"
    fi

    install -D -m "$(stat -c '%a' "$source_file")" \
        "$source_file" "$target_file"
done < <(
    find "$repo_root/Thunar" "$repo_root/gtk-3.0" "$repo_root/hypr" \
        "$repo_root/kitty" "$repo_root/quickshell" "$repo_root/rofi" \
        "$repo_root/scripts" "$repo_root/waybar" "$repo_root/xfce4" \
        "$repo_root/wallpapers" -type f -print0
    printf '%s\0' "$repo_root/pavucontrol.ini"
)

"$config_home/scripts/apply-dark-theme.sh"

printf 'Installation complete. Log out and back in to start the Hyprland setup.\n'
