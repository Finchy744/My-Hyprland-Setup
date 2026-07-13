#!/usr/bin/env bash

# =====================================================================
# =================== WALLPAPER + PYWAL + WAYBAR ======================
# =====================================================================

# --- CONFIGURATION ---
WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="${HOME}/.cache/last_wallpaper"
WAYBAR_CSS="${HOME}/.cache/wal/colors-waybar.css"
WAL_COLORS="${HOME}/.cache/wal/colors.sh"

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_JSON="$WAYBAR_CONFIG_DIR/alt.jsonc"
WAYBAR_CSS_FILE="$WAYBAR_CONFIG_DIR/alt.css"

# --- CHECK DEPENDENCIES ---
for cmd in swww wal hyprctl openrgb; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "❌ $cmd is not installed."; exit 1; }
done

# --- FIND WALLPAPERS ---
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \))
[[ ${#WALLPAPERS[@]} -eq 0 ]] && { echo "❌ No wallpapers found in $WALLPAPER_DIR"; exit 1; }

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

# --- SOURCE COLORS FILE ---
if [[ ! -f "$WAL_COLORS" ]]; then
    echo "❌ Pywal did not generate colors.sh"
    exit 1
fi
source "$WAL_COLORS"

# --- WAIT UNTIL WAYBAR CSS EXISTS AND IS READY ---
for i in {1..10}; do
    [[ -s "$WAYBAR_CSS" ]] && break
    echo "⏳ Waiting for colors-waybar.css to be ready..."
    sleep 0.5
done

[[ ! -s "$WAYBAR_CSS" ]] && { echo "❌ Error: $WAYBAR_CSS was not generated properly."; exit 1; }

# --- FUNCTION TO LAUNCH WAYBAR ALT CONFIG ---
launch_waybar_alt() {
    if [[ ! -f "$WAYBAR_JSON" || ! -f "$WAYBAR_CSS_FILE" ]]; then
        echo "❌ Waybar alt config files not found."
        return 1
    fi

    # Kill any existing Waybar
    pkill -x waybar 2>/dev/null
    sleep 0.3

    # Launch alt config
    waybar -c "$WAYBAR_JSON" -s "$WAYBAR_CSS_FILE" &
    echo "✅ Waybar (alt) launched."
}

# --- RESTART WAYBAR (with 2s delay) ---
echo "⏳ Waiting 2 seconds before launching Waybar..."
sleep 2
launch_waybar_alt

# --- RESTART NWG-DOCK ---
echo "🔁 Restarting nwg-dock-hyprland..."
pkill -f nwg-dock-hyprland
sleep 1
nwg-dock-hyprland -lp start -l bottom -i 48 -w 5 -mb 10 -ml 10 -mr 10 -c "rofi -show drun" &

# --- OPENRGB INTEGRATION (RAM ONLY) ---
MAIN_COLOR="${color1#\#}"   # remove '#' for OpenRGB

# Start OpenRGB server
openrgb --server &>/dev/null &
sleep 3  # allow device detection

# Device IDs (RAM sticks)
DRAM_IDS="0 1 2 3"

# Apply Direct mode + color to each RAM stick
for ID in $DRAM_IDS; do
    echo "🎨 Setting RAM stick $ID to #$MAIN_COLOR"
    openrgb --server -d "$ID" -m direct -c "$MAIN_COLOR"
done

echo "🌈 OpenRGB updated successfully (RAM only)."
echo "✅ Wallpaper, Pywal, Waybar (alt), and NWG-Dock updated."
