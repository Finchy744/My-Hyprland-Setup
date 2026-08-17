----------------
---- LAYOUT ----
----------------

-- Dwindle layout
hl.config({
    general = {
        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },
})


-- Master layout defaults
hl.config({
    master = {
        new_status = "master",
    },
})


-- Scrolling layout defaults
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})