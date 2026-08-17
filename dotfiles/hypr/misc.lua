-- misc.lua
-- Miscellaneous Hyprland settings


-----------------------------------------------------
-- XWayland
-----------------------------------------------------

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
        layers_hog_keyboard_focus = false,
    },
})