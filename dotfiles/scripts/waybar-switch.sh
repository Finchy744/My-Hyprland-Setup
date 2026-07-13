#!/usr/bin/env bash

# -------- CONFIG --------
CONFIG_DIR="$HOME/.config/waybar"
STATE_FILE="$HOME/.config/waybar/.current"
# ------------------------

launch_waybar() {
    local choice="$1"
    local json_file="$CONFIG_DIR/$choice.jsonc"
    local css_file="$CONFIG_DIR/$choice.css"

    if [ ! -f "$json_file" ] || [ ! -f "$css_file" ]; then
        notify-send "Waybar Switcher" "Config '$choice' is missing .jsonc or .css file."
        exit 1
    fi

    # Save state
    echo "$choice" > "$STATE_FILE"

    # Kill existing waybar
    pkill -x waybar 2>/dev/null
    sleep 0.3

    # Launch new one
    waybar -c "$json_file" -s "$css_file" &
}

choose_menu() {
    # List all .jsonc files (without extension)
    local choices
    choices=$(ls "$CONFIG_DIR"/*.jsonc 2>/dev/null | xargs -n1 basename | sed 's/\.jsonc$//')

    if [ -z "$choices" ]; then
        notify-send "Waybar Switcher" "No .jsonc configs found in $CONFIG_DIR"
        exit 1
    fi

    if command -v wofi >/dev/null 2>&1; then
        echo "$choices" | wofi --dmenu --prompt "Select Waybar"
    elif command -v rofi >/dev/null 2>&1; then
        echo "$choices" | rofi -dmenu -p "Select Waybar"
    else
        notify-send "Waybar Switcher" "No launcher found (install wofi or rofi)."
        exit 1
    fi
}

# ---- AUTO RESTORE MODE ----
if [ "$1" = "auto" ]; then
    if [ -f "$STATE_FILE" ]; then
        launch_waybar "$(cat "$STATE_FILE")"
    else
        first_config=$(ls "$CONFIG_DIR"/*.jsonc 2>/dev/null | head -n 1 | xargs -n1 basename | sed 's/\.jsonc$//')
        [ -n "$first_config" ] && launch_waybar "$first_config"
    fi
    exit 0
fi

# ---- NORMAL MODE ----
choice=$(choose_menu)

if [ -n "$choice" ]; then
    launch_waybar "$choice"
fi
