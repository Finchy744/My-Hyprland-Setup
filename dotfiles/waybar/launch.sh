#!/bin/bash

pkill waybar
waybar -c ~/.config/waybar/alt.jsonc -s ~/.config/waybar/alt.css &
