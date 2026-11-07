"""Colors the traffic lights in the screens from scripts/screenshots.sh. The window is drawn while it is not the
active one, so macOS paints its close, minimize and zoom buttons gray.

Usage: python3 -I scripts/activate-windows.py <folder with PNGs>...
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw

# Measured in the 2000 x 1280 screens: 28-pixel circles centered 46 pixels apart, 52 pixels from the top left.
CENTERS = (52, 98, 144)
RADIUS = 14
COLORS = (((255, 95, 87), (224, 68, 62)), ((254, 188, 46), (222, 161, 35)), ((40, 200, 64), (29, 173, 43)))
SCALE = 4  # Drawn larger, then reduced, for smooth edges.

for folder in sys.argv[1:]:
    for path in sorted(Path(folder).glob("*.png")):
        image = Image.open(path).convert("RGBA")
        box = (CENTERS[0] - RADIUS - 2, 52 - RADIUS - 2, CENTERS[-1] + RADIUS + 2, 52 + RADIUS + 2)
        patch = image.crop(box).resize(((box[2] - box[0]) * SCALE, (box[3] - box[1]) * SCALE), Image.LANCZOS)
        draw = ImageDraw.Draw(patch)
        for center, (fill, edge) in zip(CENTERS, COLORS):
            x, y = (center - box[0]) * SCALE, (52 - box[1]) * SCALE
            r = RADIUS * SCALE
            draw.ellipse((x - r, y - r, x + r, y + r), fill=edge)
            draw.ellipse((x - r + SCALE, y - r + SCALE, x + r - SCALE, y + r - SCALE), fill=fill)
        image.paste(patch.resize((box[2] - box[0], box[3] - box[1]), Image.LANCZOS), box[:2])
        image.save(path)
    print(f"{folder}: traffic lights colored")
