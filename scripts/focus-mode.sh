#!/usr/bin/env bash
set -euo pipefail

case "${1:-status}" in
    status)
        state=$(swaync-client --get-dnd)
        case "$state" in
            true)
                printf '{"text":"󰒲","tooltip":"Focus mode on","class":"active"}\n'
                ;;
            false)
                printf '{"text":"󰒲","tooltip":"Focus mode off","class":"inactive"}\n'
                ;;
            *)
                printf 'Unexpected Do Not Disturb state: %s\n' "$state" >&2
                exit 1
                ;;
        esac
        ;;
    toggle)
        swaync-client --toggle-dnd >/dev/null
        ;;
    *)
        printf 'Usage: %s [status|toggle]\n' "$0" >&2
        exit 2
        ;;
esac
