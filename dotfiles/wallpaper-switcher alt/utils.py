import re
from pathlib import Path

WALLPAPER_DIR = Path("/home/jordan/Pictures/Wallpapers")

SUPPORTED = {
    ".jpg",
    ".jpeg",
    ".png",
    ".webp",
    ".bmp"
}

STATE_FILE = Path.home() / ".config/hypr/wallpaper-switcher/current.txt"


def get_wallpapers():
    wallpapers = []

    for ext in SUPPORTED:
        wallpapers.extend(WALLPAPER_DIR.rglob(f"*{ext}"))
        wallpapers.extend(WALLPAPER_DIR.rglob(f"*{ext.upper()}"))

    wallpapers.sort()

    return wallpapers


def get_current_wallpaper():
    """Read the last wallpaper applied through this app, falling back to Waypaper's config."""
    if STATE_FILE.exists():
        value = STATE_FILE.read_text().strip()
        if value:
            return Path(value)

    config_path = Path.home() / ".config/waypaper/config.ini"

    if not config_path.exists():
        return None

    with open(config_path) as f:
        for line in f:
            if line.strip().startswith("wallpaper ="):
                value = line.split("=", 1)[1].strip()
                value = value.replace("~", str(Path.home()), 1) if value.startswith("~") else value
                return Path(value)

    return None


def set_current_wallpaper(wallpaper_path: Path):
    """Record the wallpaper this app just applied, so next launch highlights it correctly."""
    STATE_FILE.write_text(str(wallpaper_path))


def get_pywal_color(index=1):
    """Read a pywal color (color0-color15) from ~/.cache/wal/colors.sh"""
    colors_path = Path.home() / ".cache/wal/colors.sh"

    if not colors_path.exists():
        return None

    pattern = re.compile(rf"^color{index}='(#[0-9a-fA-F]{{6}})'")

    with open(colors_path) as f:
        for line in f:
            match = pattern.match(line.strip())
            if match:
                return match.group(1)

    return None