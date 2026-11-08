#!/usr/bin/env bash

options="  Lock\n󰤄  Suspend\n󰜉  Reboot\n  Shutdown\n󰍃  Logout"

selected=$(printf "$options" | rofi -dmenu -i -p "Power Menu")

case "$selected" in
    *Lock)      hyprlock ;;
    *Suspend)   systemctl suspend ;;
    *Reboot)    systemctl reboot ;;
    *Shutdown)  systemctl poweroff ;;
    *Logout)    hyprctl dispatch exit ;;
esac
