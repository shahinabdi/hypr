#!/usr/bin/env bash

message=$(cat <<'EOF'
SUPER + Enter       Open Kitty
SUPER + Q           Close focused window
SUPER + F           Toggle fullscreen
SUPER + R           Open app launcher
SUPER + E           Open file manager
SUPER + H           Show this keybinds window
SUPER + A           Toggle sidebar
SUPER + L           Lock screen
SUPER + Escape      Open power menu

SUPER + arrows      Change focused window
SUPER + 1-0         Switch workspace
SUPER + SHIFT + 1-0 Move window to workspace
SUPER + S           Toggle scratchpad
SUPER + SHIFT + T   Move window to scratchpad

SUPER + SHIFT + S   Region screenshot
PRINT               Fullscreen screenshot
SUPER + V           Open clipboard
SUPER + SHIFT + V   Toggle floating

Volume/brightness keys control audio and display brightness.
EOF
)

exec rofi -e "$message" -p "Hyprland keybindings"
