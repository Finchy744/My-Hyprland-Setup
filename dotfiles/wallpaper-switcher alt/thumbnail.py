import hashlib
from pathlib import Path
from PIL import Image

CACHE_DIR = Path.home() / ".config/hypr/wallpaper-switcher/cache"
CACHE_DIR.mkdir(parents=True, exist_ok=True)

THUMB_SIZE = (640, 400)


def get_thumbnail_path(wallpaper_path: Path) -> Path:
    """Return a cached thumbnail path for a given wallpaper, generating it if needed."""
    # Hash the full path so filenames never collide, even across folders
    hash_name = hashlib.sha1(str(wallpaper_path).encode()).hexdigest()
    thumb_path = CACHE_DIR / f"{hash_name}.png"

    if not thumb_path.exists():
        generate_thumbnail(wallpaper_path, thumb_path)

    return thumb_path


def generate_thumbnail(wallpaper_path: Path, thumb_path: Path):
    try:
        with Image.open(wallpaper_path) as img:
            img = img.convert("RGB")
            img.thumbnail(THUMB_SIZE, Image.LANCZOS)
            img.save(thumb_path, "PNG")
    except Exception as e:
        print(f"Failed to generate thumbnail for {wallpaper_path}: {e}")