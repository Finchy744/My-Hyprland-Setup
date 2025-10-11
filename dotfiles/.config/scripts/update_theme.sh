#!/bin/bash

# --- CONFIGURATION ---

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="${HOME}/.cache/last_wallpaper"
WAYBAR_CSS="${HOME}/.cache/wal/colors-waybar.css"
WAL_COLORS="${HOME}/.cache/wal/colors.sh"

# --- CHECK DEPENDENCIES ---

command -v swww >/dev/null 2>&1 || { echo "❌ swww is not installed."; exit 1; }
command -v wal >/dev/null 2>&1 || { echo "❌ pywal is not installed."; exit 1; }
command -v hyprctl >/dev/null 2>&1 || { echo "❌ hyprctl is not installed."; exit 1; }

# --- FIND WALLPAPERS ---

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \))
[[ ${#WALLPAPERS[@]} -eq 0 ]] && { echo "❌ No wallpapers found."; exit 1; }

# --- PICK RANDOM WALLPAPER ---

LAST_WALLPAPER=""
[[ -f "$LAST_WALLPAPER_FILE" ]] && LAST_WALLPAPER=$(<"$LAST_WALLPAPER_FILE")

NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
while [[ "$NEW_WALLPAPER" == "$LAST_WALLPAPER" && ${#WALLPAPERS[@]} -gt 1 ]]; do
    NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
done

echo "$NEW_WALLPAPER" > "$LAST_WALLPAPER_FILE"

# --- SET WALLPAPER ---

swww img "$NEW_WALLPAPER" --transition-type "any" &

# --- WAIT & GENERATE PYWAL COLORS ---

sleep 1
wal -i "$NEW_WALLPAPER" -q --backend imagemagick

# --- WAIT UNTIL WAYBAR CSS EXISTS AND IS READY ---

for i in {1..10}; do
    [[ -s "$WAYBAR_CSS" ]] && break
    echo "⏳ Waiting for colors-waybar.css to be ready..."
    sleep 0.5
done

if [[ ! -s "$WAYBAR_CSS" ]]; then
    echo "❌ Error: $WAYBAR_CSS was not generated properly."
    exit 1
fi

# --- RESTART WAYBAR ---

echo "🔁 Restarting Waybar..."
sleep 2
pkill waybar
waybar &

echo "✅ Wallpaper, pywal, and Waybar updated."



