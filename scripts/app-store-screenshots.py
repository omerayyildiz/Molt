"""Turns the screens from scripts/screenshots.sh into Mac App Store screenshots: 2560 x 1600, an ocean background,
a headline and the window below it. One set per language.

Usage: python3 -I scripts/app-store-screenshots.py   (after scripts/screenshots.sh)
Output: build/app-store-screenshots/<language>/*.png
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "build/screenshots"
OUT = ROOT / "build/app-store-screenshots"
W, H = 2560, 1600
FONT = "/System/Library/Fonts/SFNS.ttf"

CAPTIONS = {
    "en": [
        ("1-overview", "See what fills your Mac", "Every category, measured like System Settings."),
        ("3-xcode", "Know what each file is", "Trust levels, dates and sizes before anything goes."),
        ("2-projects", "Find forgotten projects", "node_modules, build output and Python environments."),
        ("4-done", "Get your space back", "One click, and Molt shows how much it freed."),
    ],
    "tr": [
        ("1-overview", "Mac'ini neyin doldurduğunu gör", "Her kategori, Sistem Ayarları'ndaki gibi ölçülür."),
        ("3-xcode", "Her dosyanın ne olduğunu bil", "Silmeden önce güven seviyesi, tarih ve boyut."),
        ("2-projects", "Unutulan projeleri bul", "node_modules, build çıktıları ve Python ortamları."),
        ("4-done", "Yerini geri al", "Tek tık; Molt ne kadar yer açtığını gösterir."),
    ],
}


def background():
    image = Image.new("RGB", (W, H))
    draw = ImageDraw.Draw(image)
    top, bottom = (29, 78, 122), (7, 26, 46)
    for y in range(H):
        t = y / (H - 1)
        draw.line([(0, y), (W, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bottom)))
    return image.convert("RGBA")


def framed(window):
    """The window with rounded corners and a soft shadow, scaled to 1800 points wide."""
    window = window.convert("RGBA").resize((1800, 1152), Image.LANCZOS)
    mask = Image.new("L", window.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *window.size), 28, fill=255)
    window.putalpha(mask)
    shadow = Image.new("RGBA", (window.width + 160, window.height + 160), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle((80, 100, 80 + window.width, 100 + window.height), 28, fill=(0, 0, 0, 150))
    shadow = shadow.filter(ImageFilter.GaussianBlur(40))
    shadow.alpha_composite(window, (80, 80))
    return shadow


for language, captions in CAPTIONS.items():
    folder = OUT / language
    folder.mkdir(parents=True, exist_ok=True)
    for index, (screen, title, subtitle) in enumerate(captions, start=1):
        image = background()
        draw = ImageDraw.Draw(image)
        title_font = ImageFont.truetype(FONT, 104)
        subtitle_font = ImageFont.truetype(FONT, 50)
        draw.text((W // 2, 150), title, font=title_font, fill=(255, 255, 255), anchor="mm")
        draw.text((W // 2, 262), subtitle, font=subtitle_font, fill=(169, 216, 230), anchor="mm")
        window = framed(Image.open(SOURCE / f"dark-{language}" / f"{screen}.png"))
        image.alpha_composite(window, ((W - window.width) // 2, 340))
        image.convert("RGB").save(folder / f"{index}-{screen[2:]}.png", optimize=True)
    print(f"{folder}: {len(captions)} screenshots")
