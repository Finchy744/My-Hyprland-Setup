#!/bin/bash

# Get number of updates
UPDATES=$(checkupdates | wc -l)

# Send a notification if there are updates
if [[ "$UPDATES" -gt 0 ]]; then
    notify-send -u normal -t 5000 "System Updates" "You have $UPDATES updates available."
fi

# Output JSON for waybar (if needed)
echo "{\"text\": \"$UPDATES updates\"}"
