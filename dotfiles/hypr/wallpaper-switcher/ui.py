import subprocess
from pathlib import Path

import gi

gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk

from utils import get_wallpapers, get_current_wallpaper, set_current_wallpaper
from carousel import WallpaperCarousel


class WallpaperWindow(Gtk.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app)

        self.set_title("Wallpaper Switcher")
        self.set_default_size(1920, 1080)
        self.fullscreen()
        self.set_decorated(False)

        self.wallpapers = get_wallpapers()
        initial_index = self.find_current_index()

        current = get_current_wallpaper()
        backdrop_path = current if current and current.exists() else None

        self.overlay = Gtk.Overlay()

        if backdrop_path is not None:
            self.backdrop = Gtk.Picture.new_for_filename(str(backdrop_path))
            self.backdrop.set_content_fit(Gtk.ContentFit.COVER)
            self.backdrop.set_hexpand(True)
            self.backdrop.set_vexpand(True)
            self.overlay.set_child(self.backdrop)

        self.carousel = WallpaperCarousel(
            self.wallpapers,
            initial_index=initial_index,
            on_apply=self.apply_wallpaper,
            on_escape=self.close,
        )
        self.carousel.set_halign(Gtk.Align.CENTER)
        self.carousel.set_valign(Gtk.Align.CENTER)

        self.overlay.add_overlay(self.carousel)

        self.set_child(self.overlay)

    def find_current_index(self):
        current = get_current_wallpaper()

        if current is None:
            return 0

        for i, wallpaper in enumerate(self.wallpapers):
            if wallpaper.resolve() == current.resolve():
                return i

        return 0

    def apply_wallpaper(self, wallpaper):
        script = "/home/jordan/.config/scripts/wallpaper-change.sh"

        subprocess.Popen(
            [script, str(wallpaper)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        set_current_wallpaper(wallpaper)
        self.close()