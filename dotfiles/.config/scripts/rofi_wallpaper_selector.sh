#!/bin/bash

# --- CONFIGURATION ---

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="${HOME}/.cache/last_wallpaper"
WAYBAR_CSS="${HOME}/.cache/wal/colors-waybar.css"

# --- CHECK DEPENDENCIES ---

command -v swww >/dev/null 2>&1 || { echo "swww is not installed."; exit 1; }
command -v wal >/dev/null 2>&1 || { echo "pywal is not installed."; exit 1; }
command -v rofi >/dev/null 2>&1 || { echo "rofi is not installed."; exit 1; }

# --- FIND WALLPAPERS ---

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \))
[[ ${#WALLPAPERS[@]} -eq 0 ]] && { echo "No wallpapers found in $WALLPAPER_DIR."; exit 1; }

# --- PREPARE BASENAMES FOR DISPLAY ---

mapfile -t BASENAMES < <(printf '%s\n' "${WALLPAPERS[@]}" | xargs -n1 basename)

# --- SHOW ROFI MENU ---

chosen_basename=$(printf '%s\n' "${BASENAMES[@]}" | rofi -dmenu -p "Select Wallpaper:")

# --- FUNCTION TO SET WALLPAPER AND COLORS ---

set_wallpaper() {
    local wallpaper="$1"
    echo "$wallpaper" > "$LAST_WALLPAPER_FILE"
    echo "Setting wallpaper to: $wallpaper"
    swww img "$wallpaper" --transition-type "any" &

    # Give swww time to update
    sleep 1

    # Generate pywal colors with imagemagick backend
    wal -i "$wallpaper" -q --backend imagemagick

    # Wait for Waybar CSS to be generated
    for i in {1..10}; do
        [[ -s "$WAYBAR_CSS" ]] && break
        echo "Waiting for colors-waybar.css to be ready..."
        sleep 0.5
    done

    if [[ ! -s "$WAYBAR_CSS" ]]; then
        echo "Error: $WAYBAR_CSS was not generated properly."
        exit 1
    fi

 # Restart Waybar
echo "Waiting 2 seconds before restarting Waybar..."
sleep 2
echo "Restarting Waybar..."
pkill waybar
waybar &


    echo "✅ Wallpaper, pywal, and Waybar updated."
}

if [[ -n "$chosen_basename" ]]; then
    # Find full path from basename
    for i in "${!BASENAMES[@]}"; do
        if [[ "${BASENAMES[i]}" == "$chosen_basename" ]]; then
            set_wallpaper "${WALLPAPERS[i]}"
            exit 0
        fi
    done

    echo "Selected wallpaper not found."
    exit 1
else
    # No selection or cancel, pick random wallpaper different from last
    LAST_WALLPAPER=""
    [[ -f "$LAST_WALLPAPER_FILE" ]] && LAST_WALLPAPER=$(<"$LAST_WALLPAPER_FILE")

    NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    while [[ "$NEW_WALLPAPER" == "$LAST_WALLPAPER" && ${#WALLPAPERS[@]} -gt 1 ]]; do
        NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    done

    set_wallpaper "$NEW_WALLPAPER"
fi
