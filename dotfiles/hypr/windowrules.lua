-- rules.lua
-- Window rules and workspace rules


-----------------------------------------------------
-- Steam Games
-----------------------------------------------------

-- Steam games always open on main monitor
hl.window_rule({
    name = "steam-monitor",

    match = {
        class = "^steam_app_.*"
    },

    monitor = "DP-2",
})


-- Steam games go to workspace 1
hl.window_rule({
    name = "steam-workspace",

    match = {
        class = "^steam_app_.*"
    },

    workspace = "1",
})

-----------------------------------------------------
-- Spotify Translucency
-----------------------------------------------------

hl.window_rule({
    name = "spotify-opacity",

    match = {
        class = "^(Spotify|spotify)$"
    },

    opacity = "0.85 0.85",
})

-----------------------------------------------------
-- Discord Translucency
-----------------------------------------------------

hl.window_rule({
    name = "discord-opacity",

    match = {
        class = "^discord$"
    },

    opacity = "0.85 0.85",
})

-----------------------------------------------------
-- HyprMod Translucency
-----------------------------------------------------

hl.window_rule({
    name = "hyprmod-opacity",

    match = {
        class = "^io\\.github\\.bluemancz\\.hyprmod$"
    },

    opacity = "0.85 0.85",
})

-----------------------------------------------------
-- Alpaca Translucency
-----------------------------------------------------

hl.window_rule({
    name = "alpaca-opacity",

    match = {
        class = "^com\\.jeffser\\.Alpaca$"
    },

    opacity = "0.85 0.85",
})   

-----------------------------------------------------
-- General Window Rules
-----------------------------------------------------

-- Ignore maximize requests
hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*"
    },

    suppress_event = "maximize",
})


-- Fix XWayland dragging issues
hl.window_rule({
    name = "fix-xwayland-drags",

    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})


-----------------------------------------------------
-- Workspace Rules
-----------------------------------------------------

-- Main monitor (DP-2)
hl.workspace_rule({
    workspace = 1,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 2,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 3,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 4,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 5,
    monitor = "DP-2",
})


-- Secondary monitor (HDMI-A-1)
hl.workspace_rule({
    workspace = 6,
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = 7,
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = 8,
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = 9,
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = 10,
    monitor = "HDMI-A-1",
})

