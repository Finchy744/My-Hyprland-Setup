#!/usr/bin/env python3
"""
waybar custom/media module
Place at ~/.config/waybar/scripts/mediaplayer.py and chmod +x it.
Matches the bindings already in config.jsonc:
  on-click        -> playerctl play-pause
  on-click-right  -> playerctl stop
  on-scroll-up    -> playerctl next
  on-scroll-down  -> playerctl previous

Requires: playerctl
"""
import json
import subprocess

ICON_PLAYING = "\U000F03E4"   # 
ICON_PAUSED = "\U000F040A"    # 
MAX_LEN = 40


def run(cmd):
    try:
        out = subprocess.run(
            cmd, capture_output=True, text=True, timeout=1.5
        )
        val = out.stdout.strip()
        return val if out.returncode == 0 and val else ""
    except Exception:
        return ""


def fmt_time(seconds):
    try:
        seconds = int(float(seconds))
    except (TypeError, ValueError):
        seconds = 0
    m, s = divmod(max(seconds, 0), 60)
    return f"{m}:{s:02d}"


def truncate(text, n):
    return text if len(text) <= n else text[: n - 1].rstrip() + "…"


PLAYER = "spotify"


def main():
    status = run(["playerctl", "-p", PLAYER, "status"])

    if not status:
        print(json.dumps({"text": "\U000F075A", "tooltip": "Spotify not running \u2014 click to toggle", "class": "none"}))
        return

    if status == "Stopped":
        print(json.dumps({"text": "", "tooltip": "Stopped", "class": "stopped"}))
        return

    artist = run(["playerctl", "-p", PLAYER, "metadata", "artist"])
    title = run(["playerctl", "-p", PLAYER, "metadata", "title"])
    if not title:
        title = run(["playerctl", "-p", PLAYER, "metadata", "xesam:title"])

    position = run(["playerctl", "-p", PLAYER, "position"])
    length_us = run(["playerctl", "-p", PLAYER, "metadata", "mpris:length"])
    length_s = int(float(length_us)) / 1_000_000 if length_us else 0

    label = f"{artist} — {title}" if artist else title
    label = label or "Unknown track"

    icon = ICON_PAUSED if status == "Paused" else ICON_PLAYING
    css_class = "paused" if status == "Paused" else "playing"

    text = truncate(f"{icon}  {label}", MAX_LEN)
    tooltip = f"{label}\n{fmt_time(position)} / {fmt_time(length_s)}"

    print(json.dumps({"text": text, "tooltip": tooltip, "class": css_class}))


if __name__ == "__main__":
    main()