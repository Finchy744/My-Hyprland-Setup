#!/bin/bash

# ---------------------------------
# Wallpaper source
# Priority:
#   1. Command line argument
#   2. Waypaper environment variable
#   3. Waypaper config
# ---------------------------------

WALLPAPER="$1"

if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER="$WAYPAPER_WALLPAPER"
fi

if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER=$(grep "^wallpaper = " ~/.config/waypaper/config.ini | cut -d' ' -f3-)
    WALLPAPER="${WALLPAPER/#\~/$HOME}"
fi

# Exit if wallpaper doesn't exist
[[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]] && exit 0

WAYBAR_CSS="$HOME/.cache/wal/colors-waybar.css"
WAL_COLORS="$HOME/.cache/wal/colors.sh"
ROFI_IMAGE="$HOME/.cache/rofi-wallpaper.png"

mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.config/rofi"

# Change wallpaper immediately
awww img "$WALLPAPER" --transition-type random &
# Let the transition begin
sleep 0.1
# ---------------------------------
# Everything else runs in background
# ---------------------------------
(
    #################################
    # Generate Pywal colors
    #################################
    wal -i "$WALLPAPER" -q --backend colorthief
    #################################
    # Generate Rofi header banner
    #################################
    magick "$WALLPAPER" \
        -resize 800x300^ \
        -gravity center \
        -extent 800x300 \
        "$ROFI_IMAGE"

    cat > "$HOME/.config/rofi/image.rasi" <<EOF
* {
    current-image: url("$ROFI_IMAGE", width);
}
EOF
    #################################
    # Generate blurred Wlogout background
    #################################
    magick "$WALLPAPER" \
        -resize 2560x1440^ \
        -gravity center \
        -extent 2560x1440 \
        -blur 0x18 \
        -brightness-contrast -25x0 \
        "$LOGOUT_IMAGE"
    #################################
    # Wait for Pywal output
    #################################
    for i in {1..20}; do
        [[ -s "$WAYBAR_CSS" ]] && break
        sleep 0.1
    done
    [[ ! -s "$WAYBAR_CSS" ]] && exit 0
    #################################
    # Load colors
    #################################
    source "$WAL_COLORS"
    MAIN_COLOR="${color1#\#}"
    #################################
    # Reload Waybar
    #################################
    pkill -SIGUSR2 waybar
    #################################
    # Ensure OpenRGB server is running
    #################################
    if ! pgrep -f "openrgb --server" > /dev/null; then
        openrgb --server &
        sleep 1
    fi
    #################################
    # Update OpenRGB
    #################################
    for ID in 0 1 2 3 4; do
        openrgb \
            --client \
            --noautoconnect \
            -d "$ID" \
            -m direct \
            -c "$MAIN_COLOR" &
    done
    wait
) &
exit 0
