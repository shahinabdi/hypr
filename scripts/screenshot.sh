#!/usr/bin/env bash

mkdir -p "$HOME/Pictures/Screenshots"

FILE="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"

case "$1" in
    region)
        grim -g "$(slurp)" "$FILE" || exit 1
        ;;
    full)
        grim "$FILE" || exit 1
        ;;
    *)
        echo "Usage: screenshot.sh [region|full]"
        exit 1
        ;;
esac

wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE"
