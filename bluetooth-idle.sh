#!/bin/bash
# Power bluetooth off after 5 consecutive minutes with no connected devices.

IDLE_LIMIT_MINUTES=5
idle=0

while true; do
    sleep 60

    if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
        idle=0
        continue
    fi

    if [ -n "$(bluetoothctl devices Connected 2>/dev/null)" ]; then
        idle=0
    else
        idle=$((idle + 1))
        if [ "$idle" -ge "$IDLE_LIMIT_MINUTES" ]; then
            bluetoothctl power off
            idle=0
        fi
    fi
done
