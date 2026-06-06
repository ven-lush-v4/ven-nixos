#!/bin/sh
floating=$(hyprctl activewindow -j | jq -r '.floating')
hyprctl dispatch togglefloating

if [ "$floating" = "false" ]; then
    sleep 0.05
    hyprctl dispatch resizeactive exact 750 400
fi
