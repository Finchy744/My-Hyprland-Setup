import hashlib
from pathlib import Path
from PIL import Image
from PIL import Image, ImageOps

CACHE_DIR = Path.home() / ".config/hypr/wallpaper-switcher/cache"
CACHE_DIR.mkdir(parents=True, exist_ok=True)

THUMB_SIZE = (640, 400)

PORTRAIT_SIZE = (300, 700)
PORTRAIT_CACHE_DIR = CACHE_DIR / "portrait"
PORTRAIT_CACHE_DIR.mkdir(parents=True, exist_ok=True)


def get_portrait_thumbnail_path(wallpaper_path: Path) -> Path:
    """Return a cached portrait-cropped thumbnail, generating it if needed."""
    hash_name = hashlib.sha1(str(wallpaper_path).encode()).hexdigest()
    thumb_path = PORTRAIT_CACHE_DIR / f"{hash_name}.png"

    if not thumb_path.exists():
        generate_portrait_thumbnail(wallpaper_path, thumb_path)

    return thumb_path


def generate_portrait_thumbnail(wallpaper_path: Path, thumb_path: Path):
    try:
        with Image.open(wallpaper_path) as img:
            img = img.convert("RGB")
            # Center-crop to a tall portrait shape, then resize
            fitted = ImageOps.fit(img, PORTRAIT_SIZE, Image.LANCZOS, centering=(0.5, 0.4))
            fitted.save(thumb_path, "PNG")
    except Exception as e:
        print(f"Failed to generate portrait thumbnail for {wallpaper_path}: {e}")

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