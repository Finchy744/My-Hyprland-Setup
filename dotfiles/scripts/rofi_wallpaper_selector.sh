#!/bin/bash

# --- CONFIGURATION ---

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="${HOME}/.cache/last_wallpaper"
WAYBAR_CSS="${HOME}/.cache/wal/colors-waybar.css"
WAL_COLORS="${HOME}/.cache/wal/colors.sh"

# --- CHECK DEPENDENCIES ---

command -v swww >/dev/null 2>&1 || { echo "swww is not installed."; exit 1; }
command -v wal >/dev/null 2>&1 || { echo "pywal is not installed."; exit 1; }
command -v rofi >/dev/null 2>&1 || { echo "rofi is not installed."; exit 1; }
command -v openrgb >/dev/null 2>&1 || { echo "openrgb is not installed."; exit 1; }

# --- FIND WALLPAPERS ---

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \))
[[ ${#WALLPAPERS[@]} -eq 0 ]] && { echo "No wallpapers found in $WALLPAPER_DIR."; exit 1; }

# --- PREPARE BASENAMES FOR DISPLAY ---

mapfile -t BASENAMES < <(printf '%s\n' "${WALLPAPERS[@]}" | xargs -n1 basename)

# --- SHOW ROFI MENU ---

chosen_basename=$(printf '%s\n' "${BASENAMES[@]}" | rofi -dmenu -p "Select Wallpaper:")

# --------------------------------------------------------------------
#  FUNCTION: Set wallpaper + generate pywal + update Waybar & OpenRGB
# --------------------------------------------------------------------

set_wallpaper() {
    local wallpaper="$1"
    echo "$wallpaper" > "$LAST_WALLPAPER_FILE"
    echo "Setting wallpaper to: $wallpaper"

    # --- Set wallpaper with original transition speed ---
    swww img "$wallpaper" --transition-type "any" &
    sleep 1   # restore previous feel

    # --- Generate pywal colors quickly ---
    wal -i "$wallpaper" -q --backend imagemagick

    # --- Wait for colors.sh & colors-waybar.css ---
    for i in {1..10}; do
        [[ -s "$WAYBAR_CSS" ]] && break
        sleep 0.1
    done

    if [[ ! -s "$WAYBAR_CSS" ]]; then
        echo "Error: $WAYBAR_CSS was not generated properly."
        exit 1
    fi

    # --- Load pywal colors ---
    source "$WAL_COLORS"
    MAIN_COLOR="${color1#\#}"  # remove # for OpenRGB

    # ----------------------------------------------------------------
    # --- WAYBAR INSTANT CSS RELOAD (NO RESTART!) ---
    # ----------------------------------------------------------------
    echo "🔁 Reloading Waybar CSS instantly..."
    pkill -SIGUSR2 waybar

    # ----------------------------------------------------------------
    # --- OPENRGB INSTANT COLOR UPDATE (RAM 0–3, GPU 4) ---
    # ----------------------------------------------------------------
    DRAM_IDS="0 1 2 3"
    GPU_ID="4"

    # Apply Direct mode + color instantly via persistent server
    for ID in $DRAM_IDS; do
        openrgb --client --noautoconnect -d "$ID" -m direct -c "$MAIN_COLOR"
    done

    openrgb --client --noautoconnect -d "$GPU_ID" -m direct -c "$MAIN_COLOR"

    echo "🌈 OpenRGB updated instantly."
    echo "✅ Wallpaper, pywal, Waybar, and OpenRGB updated."
}

# --------------------------------------------------------------------
# If user selected a wallpaper in rofi
# --------------------------------------------------------------------

if [[ -n "$chosen_basename" ]]; then
    for i in "${!BASENAMES[@]}"; do
        if [[ "${BASENAMES[i]}" == "$chosen_basename" ]]; then
            set_wallpaper "${WALLPAPERS[i]}"
            exit 0
        fi
    done

    echo "Selected wallpaper not found."
    exit 1

else
    # No selection → Random wallpaper
    LAST_WALLPAPER=""
    [[ -f "$LAST_WALLPAPER_FILE" ]] && LAST_WALLPAPER=$(<"$LAST_WALLPAPER_FILE")

    NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    while [[ "$NEW_WALLPAPER" == "$LAST_WALLPAPER" && ${#WALLPAPERS[@]} -gt 1 ]]; do
        NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    done

    set_wallpaper "$NEW_WALLPAPER"
fi
