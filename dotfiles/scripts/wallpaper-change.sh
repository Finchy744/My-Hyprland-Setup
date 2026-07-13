#!/bin/bash

# Try getting wallpaper from environment variable first
WALLPAPER="$WAYPAPER_WALLPAPER"

# If empty, read from config file
if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER=$(grep "^wallpaper = " ~/.config/waypaper/config.ini | cut -d' ' -f3-)
    WALLPAPER="${WALLPAPER/#\~/$HOME}"  # expand ~
fi

WAYBAR_CSS="${HOME}/.cache/wal/colors-waybar.css"
WAL_COLORS="${HOME}/.cache/wal/colors.sh"

# Exit if no wallpaper
[[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]] && exit 0

# Generate pywal colors
wal -i "$WALLPAPER" -q --backend imagemagick

# Wait for Waybar CSS
for i in {1..10}; do
    [[ -s "$WAYBAR_CSS" ]] && break
    sleep 0.1
done

[[ ! -s "$WAYBAR_CSS" ]] && exit 0

# Load colors
source "$WAL_COLORS"
MAIN_COLOR="${color1#\#}"

# Wait for wallpaper transition to finish
sleep 2

# Waybar reload
pkill -SIGUSR2 waybar

# --- RESTART NWG-DOCK ---
echo "🔁 Restarting nwg-dock-hyprland..."
pkill -f nwg-dock-hyprland
sleep 1
nwg-dock-hyprland -lp start -l bottom -i 48 -w 5 -mb 10 -ml 10 -mr 10 -c "rofi -show drun" &

# OpenRGB update (RAM 0-3, GPU 4)
for ID in 0 1 2 3 4; do
    openrgb --client --noautoconnect -d "$ID" -m direct -c "$MAIN_COLOR"
done
