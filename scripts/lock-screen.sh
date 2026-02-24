#!/bin/bash
# Run hyprlock reliably from menu
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
exec hyprlock
