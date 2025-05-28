#!/bin/bash

# Configuration
BATTERY_PATH="/sys/class/power_supply/BAT1"  # Adjust if your battery has a different name
THRESHOLD=25                                 # Notify when battery is below this percentage
CHECK_INTERVAL=60                            # Check battery every X seconds
NOTIFY_REPEATED_INTERVAL=300                 # Send repeated notifications every X seconds (5 minutes)
LAST_NOTIFICATION_TIME=0                     # Initialize last notification time

while true; do
    # Check if battery is discharging
    STATUS=$(cat "$BATTERY_PATH/status")
    
    # Only check level if battery is discharging
    if [ "$STATUS" = "Discharging" ]; then
        # Get current battery percentage
        CAPACITY=$(cat "$BATTERY_PATH/capacity")
        
        # Get current time in seconds since epoch
        CURRENT_TIME=$(date +%s)
        
        # Check if battery is below threshold and if it's time for a notification
        if [ "$CAPACITY" -le "$THRESHOLD" ] && [ $((CURRENT_TIME - LAST_NOTIFICATION_TIME)) -ge "$NOTIFY_REPEATED_INTERVAL" ]; then
            notify-send -u critical "Battery Low" "Battery level is ${CAPACITY}%"
            LAST_NOTIFICATION_TIME=$CURRENT_TIME
        fi
    else
        # Reset notification time when charging
        LAST_NOTIFICATION_TIME=0
    fi
    
    # Sleep to avoid constant checking
    sleep $CHECK_INTERVAL
done
