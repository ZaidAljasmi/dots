#!/usr/bin/env bash

last_layout=""

swaymsg -m -t subscribe '["input"]' | jq --unbuffered -c '
    select(.change=="xkb_layout") |
    .input.xkb_active_layout_name
' | while read -r layout
do
    [ -z "$layout" ] && continue

    if [ "$layout" = "$last_layout" ]; then
        continue
    fi

    last_layout="$layout"

    notify-send -a "keyboard" "Layout changed" "$layout"
done
