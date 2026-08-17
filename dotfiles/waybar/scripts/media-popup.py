#!/usr/bin/env python3
"""
Standalone GTK layer-shell popup for Spotify controls, in the style of a
wlogout-type menu. Runs persistently in the background; toggled by sending
it SIGUSR1 (waybar's on-click does this).

Requires: gtk-layer-shell, python-gobject
  sudo pacman -S gtk-layer-shell python-gobject

Autostart in hyprland.conf:
  exec-once = python3 ~/.config/waybar/scripts/media-popup.py

Toggle from waybar (on-click):
  pkill -SIGUSR1 -f media-popup.py
"""
import gi
import hashlib
import os
import signal
import subprocess
import urllib.request

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gtk, GLib, GtkLayerShell, Gdk, GdkPixbuf

PLAYER = "spotify"

# Tune these two to sit the popup under your media module in the bar.
# Increase MARGIN_RIGHT to move it further left, decrease to move it right.
MARGIN_TOP = 48
MARGIN_RIGHT = 340

ART_SIZE = 120
ART_CACHE_DIR = "/tmp/media-popup-art"

CSS_PATH = GLib.get_home_dir() + "/.config/waybar/scripts/media-popup.css"


def run(cmd):
    try:
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=1.5)
        return out.stdout.strip()
    except Exception:
        return ""


def load_art_pixbuf(art_url):
    if not art_url:
        return None
    try:
        if art_url.startswith("file://"):
            path = art_url[len("file://"):]
        elif art_url.startswith("http://") or art_url.startswith("https://"):
            os.makedirs(ART_CACHE_DIR, exist_ok=True)
            h = hashlib.md5(art_url.encode()).hexdigest()
            path = os.path.join(ART_CACHE_DIR, h)
            if not os.path.exists(path):
                urllib.request.urlretrieve(art_url, path)
        else:
            return None
        return GdkPixbuf.Pixbuf.new_from_file_at_scale(path, ART_SIZE, ART_SIZE, True)
    except Exception:
        return None


class MediaPopup(Gtk.Window):
    def __init__(self):
        super().__init__(title="media-popup")
        self.set_decorated(False)
        self.set_default_size(480, 180)
        self.get_style_context().add_class("media-popup")

        GtkLayerShell.init_for_window(self)

        display = Gdk.Display.get_default()
        for i in range(display.get_n_monitors()):
            m = display.get_monitor(i)
            if m.get_model() == "LG ULTRAGEAR":
                GtkLayerShell.set_monitor(self, m)
                break

        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, MARGIN_TOP)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, MARGIN_RIGHT)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.NONE)
        GtkLayerShell.set_exclusive_zone(self, -1)

        outer = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=20)
        outer.set_border_width(24)
        self.add(outer)

        self.art_image = Gtk.Image()
        self.art_image.get_style_context().add_class("media-art")
        self.art_image.set_size_request(ART_SIZE, ART_SIZE)
        outer.pack_start(self.art_image, False, False, 0)

        col = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=16)
        col.set_valign(Gtk.Align.CENTER)
        outer.pack_start(col, True, True, 0)

        self.title_label = Gtk.Label(label="")
        self.title_label.set_line_wrap(True)
        self.title_label.set_max_width_chars(38)
        self.title_label.set_xalign(0)
        self.title_label.get_style_context().add_class("media-title")
        col.pack_start(self.title_label, False, False, 0)

        btn_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=24)
        col.pack_start(btn_box, False, False, 0)

        prev_btn = Gtk.Button(label="\U000F04AE")   # 
        self.playpause_btn = Gtk.Button(label="\U000F040A")  # 
        next_btn = Gtk.Button(label="\U000F04AD")   # 

        prev_btn.connect("clicked", lambda w: run(["playerctl", "-p", PLAYER, "previous"]))
        self.playpause_btn.connect("clicked", lambda w: run(["playerctl", "-p", PLAYER, "play-pause"]))
        next_btn.connect("clicked", lambda w: run(["playerctl", "-p", PLAYER, "next"]))

        for b in (prev_btn, self.playpause_btn, next_btn):
            b.get_style_context().add_class("media-btn")
            btn_box.pack_start(b, False, False, 0)

        self.current_art_url = None

        self.show_all()
        self.set_visible(False)
        GLib.timeout_add(1000, self.refresh)

    def refresh(self):
        if self.get_visible():
            status = run(["playerctl", "-p", PLAYER, "status"])
            if not status:
                self.title_label.set_text("Spotify not running")
                self.playpause_btn.set_label("\U000F040A")
                if self.current_art_url is not None:
                    self.current_art_url = None
                    self.art_image.clear()
            else:
                artist = run(["playerctl", "-p", PLAYER, "metadata", "artist"])
                title = run(["playerctl", "-p", PLAYER, "metadata", "title"])
                label = f"{artist} — {title}" if artist else title
                self.title_label.set_text(label or "Unknown track")
                self.playpause_btn.set_label(
                    "\U000F040A" if status == "Paused" else "\U000F03E4"
                )

                art_url = run(["playerctl", "-p", PLAYER, "metadata", "mpris:artUrl"])
                if art_url != self.current_art_url:
                    self.current_art_url = art_url
                    pixbuf = load_art_pixbuf(art_url)
                    if pixbuf:
                        self.art_image.set_from_pixbuf(pixbuf)
                    else:
                        self.art_image.clear()
        return True

    def toggle(self, *args):
        self.set_visible(not self.get_visible())
        return True


def load_css():
    provider = Gtk.CssProvider()
    provider.load_from_path(CSS_PATH)
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )


def main():
    load_css()
    win = MediaPopup()
    GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR1, win.toggle)
    Gtk.main()


if __name__ == "__main__":
    main()
