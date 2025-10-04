#!/bin/bash

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="${HOME}/.cache/last_wallpaper"

# Check swww
if ! command -v swww >/dev/null 2>&1; then
    echo "swww is not installed. Please install swww."
    exit 1
fi

# Gather wallpapers (full paths)
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR."
    exit 1
fi

# Show Rofi menu with basenames and get user choice
# Use basename for cleaner display but keep full paths indexed
mapfile -t BASENAMES < <(printf '%s\n' "${WALLPAPERS[@]}" | xargs -n1 basename)
chosen_basename=$(printf '%s\n' "${BASENAMES[@]}" | rofi -dmenu -p "Select Wallpaper:")

# Function to set wallpaper and update colors
set_wallpaper() {
    local wallpaper="$1"
    echo "$wallpaper" > "$LAST_WALLPAPER_FILE"
    echo "Setting wallpaper to: $wallpaper"
    swww img "$wallpaper" --transition-type "any" &

    # Give swww some time to update wallpaper before generating colors
    sleep 3

    if command -v matugen >/dev/null 2>&1; then
        echo "Generating color palette with matugen..."
        matugen image "$wallpaper" --show-colors -m "dark"
    fi

    if command -v wal >/dev/null 2>&1; then
        wal -i "$wallpaper" -q

        # Update rofi theme to match Pywal colors
        if [[ -f "${HOME}/.cache/wal/colors-rofi-dark.rasi" ]]; then
            ln -sf "${HOME}/.cache/wal/colors-rofi-dark.rasi" "${HOME}/.config/rofi/colors.rasi"
        fi
    fi

    echo "Colors and wallpaper updated successfully."
}

if [[ -n "$chosen_basename" ]]; then
    # User selected something from rofi
    # Find full path corresponding to chosen basename
    for i in "${!BASENAMES[@]}"; do
        if [[ "${BASENAMES[i]}" == "$chosen_basename" ]]; then
            set_wallpaper "${WALLPAPERS[i]}"
            exit 0
        fi
    done

    echo "Selected wallpaper not found. Exiting."
    exit 1
else
    # No selection or cancelled - pick random wallpaper different from last one

    LAST_WALLPAPER=""
    if [[ -f "$LAST_WALLPAPER_FILE" ]]; then
        LAST_WALLPAPER=$(<"$LAST_WALLPAPER_FILE")
    fi

    NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    if [[ "$NEW_WALLPAPER" == "$LAST_WALLPAPER" ]] && [[ ${#WALLPAPERS[@]} -gt 1 ]]; then
        while [[ "$NEW_WALLPAPER" == "$LAST_WALLPAPER" ]]; do
            NEW_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
        done
    fi

    set_wallpaper "$NEW_WALLPAPER"
fi


