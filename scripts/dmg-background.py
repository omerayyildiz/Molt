#!/usr/bin/env python3
# Draws the DMG window's background: an arrow from Molt to Applications and the crab peeking in.
# Output: scripts/dmg-background.tiff (660 x 340 points, regular and Retina).
#
# Usage: python3 -I scripts/dmg-background.py
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
WIDTH, HEIGHT = 660, 340
BACKGROUND = (238, 240, 243)
ARROW = (176, 182, 192)
SUPERSAMPLE = 4


def draw(scale):
    s = scale * SUPERSAMPLE
    canvas = Image.new("RGB", (WIDTH * s, HEIGHT * s), BACKGROUND)
    pen = ImageDraw.Draw(canvas)

    def dot(x, y, radius):
        pen.ellipse([(x - radius) * s, (y - radius) * s, (x + radius) * s, (y + radius) * s], fill=ARROW)

    def bezier(t):
        start, control, end = (262, 162), (330, 122), (398, 162)
        return tuple((1 - t) ** 2 * a + 2 * (1 - t) * t * b + t**2 * c for a, b, c in zip(start, control, end))

    for step in range(601):
        dot(*bezier(step / 600), 2)
    # The head follows the curve's last direction, so it points down at Applications.
    for start in ((381, 164), (394, 145)):
        for step in range(201):
            t = step / 200
            dot(start[0] + (398 - start[0]) * t, start[1] + (162 - start[1]) * t, 2)

    crab = Image.open(ROOT / "Molt/Assets.xcassets/MascotScanning.imageset/MascotScanning.png").convert("RGBA")
    width = 128 * s
    crab = crab.resize((width, round(crab.height * width / crab.width)), Image.LANCZOS)
    # A little of the claws falls below the window, so the crab looks in from the bottom edge.
    canvas.paste(crab, ((WIDTH * s - width) // 2, HEIGHT * s - round(crab.height * 0.86)), crab)
    return canvas.resize((WIDTH * scale, HEIGHT * scale), Image.LANCZOS)


with tempfile.TemporaryDirectory() as folder:
    regular, retina = Path(folder) / "regular.tiff", Path(folder) / "retina.tiff"
    draw(1).save(regular, dpi=(72, 72))
    draw(2).save(retina, dpi=(144, 144))
    subprocess.run(
        ["tiffutil", "-cathidpicheck", str(regular), str(retina), "-out", str(ROOT / "scripts/dmg-background.tiff")],
        check=True,
    )
print("scripts/dmg-background.tiff")
