-- binds.lua
-- Application and custom script keybinds

local home = os.getenv("HOME")

local mainMod = "SUPER"

---------------------
-- Applications
---------------------

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun"
local browser = "zen-browser"


-- Terminal
hl.bind(
    mainMod .. " + Z",
    hl.dsp.exec_cmd(terminal)
)

-- File manager
hl.bind(
    mainMod .. " + A",
    hl.dsp.exec_cmd(fileManager)
)

-- App launcher
hl.bind(
    mainMod .. " + CTRL + RETURN",
    hl.dsp.exec_cmd(menu)
)

-- Browser
hl.bind(
    mainMod .. " + X",
    hl.dsp.exec_cmd(browser)
)

-- VS Code
hl.bind(
    mainMod .. " + L",
    hl.dsp.exec_cmd("code")
)

-- Alpaca Launcher
hl.bind(
    mainMod .. " + SHIFT + A",
    hl.dsp.exec_cmd("alpaca")
)

---------------------
-- Custom scripts
---------------------

-- Restart / launch Waybar
hl.bind(
    mainMod .. " + SHIFT + B",
    hl.dsp.exec_cmd(
        home .. "/.config/waybar/launch.sh"
    )
)


-- Steam
hl.bind(
    mainMod .. " + SHIFT + S",
    hl.dsp.exec_cmd("steam")
)

-- Screenshot
hl.bind(
    mainMod .. " + O",
    hl.dsp.exec_cmd(
        "hyprshot -m output"
    )
)

-- Flameshot screenshot
hl.bind(
    mainMod .. " + SHIFT + O",
    hl.dsp.exec_cmd(
        "flameshot gui"
    )
)


-- Heroic Launcher
hl.bind(
    mainMod .. " + SHIFT + H",
    hl.dsp.exec_cmd("heroic games launcher")
)


-- Update theme
hl.bind(
    mainMod .. " + SHIFT + W",
    hl.dsp.exec_cmd(
        home .. "/.config/scripts/update_theme.sh"
    )
)


-- Wlogout
hl.bind(
    mainMod .. " + SHIFT + L",
    hl.dsp.exec_cmd(
        home .. "/.config/scripts/launch.wlogout.sh"
    )
)


-- Gamemode
hl.bind(
    mainMod .. " + SHIFT + G",
    hl.dsp.exec_cmd(
        home .. "/.config/scripts/gamemode.sh"
    )
)


-- Discord
hl.bind(
    mainMod .. " + SHIFT + D",
    hl.dsp.exec_cmd("discord")
)


-- Wallpaper switcher
hl.bind(
    mainMod .. " + SHIFT + Q",
    hl.dsp.exec_cmd(
        "python " .. home .. "/.config/hypr/wallpaper-switcher/switcher.py"
    )
)

-- Restart dock
hl.bind(
    mainMod .. " + SHIFT + N",
    hl.dsp.exec_cmd(
        home .. "/.config/scripts/restart-dock.sh"
    )
)


-- Waybar switch
hl.bind(
    mainMod .. " + B",
    hl.dsp.exec_cmd(
        home .. "/.config/scripts/waybar-switch.sh"
    )
)


-- Screenshot
hl.bind(
    mainMod .. " + O",
    hl.dsp.exec_cmd(
        "hyprshot -m output"
    )
)

-------------------------
-- Window Management
-------------------------

-- Move focus between columns
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.layout("move -col"))

-- Move the whole scrolling view by one column
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("move -col"))

-- Swap current column with its neighbor
hl.bind(mainMod .. " + ALT + h", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + ALT + l", hl.dsp.layout("swapcol r"))

-- Resize the current column (cycles through preset widths: 33%, 50%, 67%, 100%)
hl.bind(mainMod .. " + r", hl.dsp.layout("colresize +conf"))

-- Pop the focused window into its own new column
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.layout("promote"))

-- Pull the current window back into the previous column (undo a promote/expel)
hl.bind(mainMod .. " + c", hl.dsp.layout("consume"))

-- Fullscreen
hl.bind(
    mainMod .. " + F",
    hl.dsp.window.fullscreen()
)

-- Close active window
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)

-- Kill window
hl.bind(
    mainMod .. " + DELETE",
    hl.dsp.exec_cmd("hyprctl kill")
)

-- Exit Hyprland
hl.bind(
    mainMod .. " + M",
    hl.dsp.exit()
)

-- Toggle floating
hl.bind(
    mainMod .. " + T",
    hl.dsp.window.float({ action = "toggle" })
)

-- Toggle pseudo
hl.bind(
    mainMod .. " + P",
    hl.dsp.window.pseudo()
)

-- Hyprlock
hl.bind(
    mainMod .. " + SHIFT + K",
    hl.dsp.exec_cmd("hyprlock")
)

-------------------------
-- Window Focus
-------------------------

hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({ direction = "down" })
)


-------------------------
-- Workspaces
-------------------------

for i = 1, 10 do
    local key = i % 10

    -- Switch workspace
    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({
            workspace = i
        })
    )

    -- Move window to workspace
    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i
        })
    )
end


-------------------------
-- Workspace scrolling
-------------------------

hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({
        workspace = "e+1"
    })
)

hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({
        workspace = "e-1"
    })
)


-------------------------
-- Mouse window movement
-------------------------

hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true
    }
)

hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true
    }
)

-------------------------
-- Volume Controls
-------------------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)


-------------------------
-- Media Controls
-------------------------

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd(
        "playerctl next"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd(
        "playerctl play-pause"
    ),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd(
        "playerctl previous"
    ),
    {
        locked = true
    }
)


-------------------------
-- Brightness Controls
-------------------------

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%+"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%-"
    ),
    {
        locked = true,
        repeating = true
    }
)