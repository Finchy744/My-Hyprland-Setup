#!/usr/bin/env python3
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))

import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, Gdk

from ui import WallpaperWindow


class WallpaperApp(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="com.jordan.wallpaperswitcher")

    def do_activate(self):
        self.load_css()
        win = WallpaperWindow(self)
        win.present()

    def load_css(self):
        provider = Gtk.CssProvider()
        css_path = SCRIPT_DIR / "style.css"
        provider.load_from_path(str(css_path))

        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )


def main():
    app = WallpaperApp()
    app.run(None)


if __name__ == "__main__":
    main()