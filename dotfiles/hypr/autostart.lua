-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()

    -- Update environment for Wayland apps
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland"
    )


    -- Keyring
    hl.exec_cmd(
        "gnome-keyring-daemon --start --components=secrets"
    )


    -- Wallpaper system
    hl.exec_cmd("aww-daemon &")
    hl.exec_cmd("sleep 2 && waypaper --restore")


    -- Wallpaper engine
    hl.exec_cmd("~/.config/scripts/Wallpaper_engine.sh")


    -- Sync icons
    hl.exec_cmd("~/.config/scripts/icon-sync.sh")


    -- Waybar theme switcher
    hl.exec_cmd("~/.config/scripts/waybar-switch.sh auto")


    -- Status bar
    hl.exec_cmd("waybar &")

    -- Media popup daemon
    hl.exec_cmd("python3 ~/.config/waybar/scripts/media-popup.py &")

 hl.exec_cmd(
    "sleep 3 && nwg-dock-hyprland -o DP-2 -lp start -l bottom -d -i 48 -w 5 -mb 10 -ml 10 -mr 10 -c 'rofi -show drun' -ico ~/.config/nwg-dock-hyprland/images/cachyos-logo-transparent.png"
)

    -- Idle daemon
    hl.exec_cmd("hypridle &")

    -- Force DP-2 as X11/Xwayland primary monitor
    hl.exec_cmd("sleep 2 && xrandr --output DP-2 --primary")

end)

