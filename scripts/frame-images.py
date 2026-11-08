"""Frames images for the README and the website: rounded corners, a hairline border and a soft two-layer
shadow on a transparent background, so they sit well on GitHub's light and dark themes.

Usage: python3 -I scripts/frame-images.py   (after scripts/screenshots.sh)
"""
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SHOTS = ROOT / "build/screenshots"
DOCS = ROOT / "docs/images"
WEB = ROOT / "website/assets"


def rounded(image, radius):
    mask = Image.new("L", image.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, image.width - 1, image.height - 1), radius, fill=255)
    image = image.convert("RGBA")
    image.putalpha(ImageChops.multiply(image.getchannel("A"), mask))
    return image, mask


def framed(image, radius, margin):
    """The image with a hairline border, on a transparent canvas with a wide soft shadow and a tight one."""
    image, mask = rounded(image, radius)
    border = Image.new("RGBA", image.size, (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle((0, 0, image.width - 1, image.height - 1), radius, outline=(14, 16, 20, 30), width=2)
    image.alpha_composite(border)

    canvas = Image.new("RGBA", (image.width + 2 * margin, image.height + 2 * margin), (0, 0, 0, 0))
    for blur, offset, alpha in ((margin * 0.55, margin * 0.35, 70), (6, 3, 40)):
        shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        layer = Image.new("RGBA", image.size, (16, 24, 40, alpha))
        layer.putalpha(ImageChops.multiply(mask, Image.new("L", image.size, alpha)))
        shadow.alpha_composite(layer, (margin, margin + round(offset)))
        canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(blur)))
    canvas.alpha_composite(image, (margin, margin))
    return canvas


# README: three light screens, framed.
DOCS.mkdir(parents=True, exist_ok=True)
for source, name in (("1-overview", "overview"), ("2-projects", "projects"), ("4-done", "done")):
    framed(Image.open(SHOTS / "light-en" / f"{source}.png"), radius=24, margin=80).save(DOCS / f"{name}.png", optimize=True)
    print(f"docs/images/{name}.png")

# README: the crab scene, transparent so it sits on GitHub's light and dark pages.
Image.open(WEB / "mascot-scene.webp").save(DOCS / "mascot.png", optimize=True)
print("docs/images/mascot.png")

# Website: plain screens (the page draws its own frame), both languages, both themes.
for language in ("en", "tr"):
    for theme in ("light", "dark"):
        for source, name in (("1-overview", "overview"), ("2-projects", "projects")):
            image = Image.open(SHOTS / f"{theme}-{language}" / f"{source}.png").convert("RGB").resize((1600, 1024), Image.LANCZOS)
            image.save(WEB / f"{name}-{language}-{theme}.webp", "WEBP", quality=86, method=6)
            print(f"website/assets/{name}-{language}-{theme}.webp")
