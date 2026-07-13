#!/usr/bin/env bash

set -eu

for output in DP-1 DP-2 HDMI-A-1; do
    if swaymsg -t get_outputs -r | jq -e --arg output "$output" '.[] | select(.name == $output and .active)' >/dev/null; then
        swaymsg output "$output" mode 2560x1440@120Hz
        exit 0
    fi
done
