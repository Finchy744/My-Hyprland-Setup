-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- WAYLAND/NVIDIA ---
-----------------------

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch-")

hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
--hl.env("__GL_GSYNC_ALLOWED", "1")
--hl.env("__GL_VRR_ALLOWED", "1")


-----------------------
--------- QT ----------
-----------------------

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")