#!/bin/bash

# Define icons (plain bell)
ICON_ENABLED="󰂚"    # Bell active
ICON_DISABLED=""   # Same bell, no slash

# Optional: add color class in Waybar JSON
if pgrep -x "mako" > /dev/null; then
    ICON="$ICON_ENABLED"
    TOOLTIP="Notifications Enabled"
    COLOR=""  # use default foreground
else
    ICON="$ICON_DISABLED"
    TOOLTIP="Notifications Disabled"
    COLOR="@color4"  # example: red or muted
fi

# Output JSON for Waybar
echo "{\"text\": \"$ICON\", \"tooltip\": \"$TOOLTIP\"}"
