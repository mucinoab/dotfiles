#!/bin/bash
# Run the laptop panel at 48 Hz in the power-saver profile, 60 Hz otherwise.
# Reacts to power profile changes and to output changes (e.g. shikane switching profiles).

apply() {
    if [ "$(powerprofilesctl get)" = power-saver ]; then
        want=47998 mode=47.998Hz
    else
        want=59999 mode=59.999Hz
    fi
    cur=$(swaymsg -r -t get_outputs | jq '.[] | select(.name == "eDP-1" and .active) | .current_mode.refresh')
    # Only change when it differs, so our own output event doesn't loop.
    if [ -n "$cur" ] && [ "$cur" != "$want" ]; then
        swaymsg -q output eDP-1 mode "2256x1504@$mode"
    fi
}

apply
{
    gdbus monitor --system --dest org.freedesktop.UPower.PowerProfiles \
        --object-path /org/freedesktop/UPower/PowerProfiles &
    swaymsg -m -t subscribe '["output"]'
} | while read -r _; do
    apply
done
