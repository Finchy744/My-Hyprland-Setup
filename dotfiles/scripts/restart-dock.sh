#!/bin/bash
# restart-dock.sh

# Kill existing dock
pkill -f nwg-dock-hyprland

# Wait a bit for it to fully exit
sleep 0.5

# Start a fresh dock
nwg-dock-hyprland -o DP-2 -lp start -l bottom -d -i 48 -w 5 -mb 10 -ml 10 -mr 10 -c 'rofi -show drun' -ico ~/.config/nwg-dock-hyprland/images/cachyos-logo-transparent.png &
