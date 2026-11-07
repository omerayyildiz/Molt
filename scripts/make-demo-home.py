"""Creates a made-up home folder with typical developer clutter, for screenshots that show no one's real files.

Usage: python3 -I scripts/make-demo-home.py <folder>

About 4.4 GB of zero-filled files (they take real space, so sizes look real). Delete the folder afterwards.
"""
import os
import sys
import time
from pathlib import Path

MB = 1024 * 1024
DAY = 86_400
home = Path(sys.argv[1])
now = time.time()


def fill(path, megabytes, days_old=1):
    """One folder holding `megabytes` of data, last changed `days_old` days ago."""
    path.mkdir(parents=True, exist_ok=True)
    chunk = b"\0" * MB
    with open(path / "data.bin", "wb") as file:
        for _ in range(megabytes):
            file.write(chunk)
    stamp = now - days_old * DAY
    os.utime(path / "data.bin", (stamp, stamp))
    os.utime(path, (stamp, stamp))


def project(folder, marker, artifact, megabytes, days_old):
    root = home / "Developer" / folder
    root.mkdir(parents=True, exist_ok=True)
    (root / marker).write_text("{}\n")
    fill(root / artifact, megabytes, days_old)
    stamp = now - days_old * DAY
    os.utime(root / marker, (stamp, stamp))


xcode = home / "Library/Developer/Xcode"
fill(xcode / "DerivedData/Weather-bxqzkhfmvlrdwe", 210, 2)
fill(xcode / "DerivedData/Recipes-ckwhxyzuopqmab", 140, 9)
fill(xcode / "DerivedData/ModuleCache.noindex", 95, 1)
fill(xcode / "iOS DeviceSupport/iPhone17,1 26.0 (23A341)", 160, 40)
fill(xcode / "Archives/2026-09-14", 70, 54)
fill(xcode / "DerivedData/Molt-gbzfqkrtnvpwdo", 180, 0)
fill(xcode / "DerivedData/Habits-dkqzxmrwplsnte", 120, 33)
fill(xcode / "iOS DeviceSupport/iPhone16,2 18.6 (22G86)", 140, 120)
fill(xcode / "Archives/2026-07-02", 64, 128)
fill(home / "Library/Developer/CoreSimulator/Caches/dyld", 120, 6)
fill(home / "Library/iTunes/iPad Software Updates", 330, 75)

project("shop-frontend", "package.json", "node_modules", 280, 160)
project("portfolio", "package.json", "node_modules", 150, 12)
project("portfolio", "package.json", ".next", 60, 12)
project("tiny-api", "Cargo.toml", "target", 190, 95)
project("notebook", "pyproject.toml", ".venv", 120, 210)
project("dashboard", "package.json", "node_modules", 340, 40)
project("blog", "package.json", "node_modules", 220, 130)
project("design-system", "package.json", "node_modules", 180, 70)
project("docs-site", "package.json", ".next", 90, 15)
project("mobile-app", "Podfile", "Pods", 260, 120)
project("cli-tool", "Cargo.toml", "target", 150, 25)
project("ml-experiments", "pyproject.toml", ".venv", 310, 300)

fill(home / ".npm/_cacache", 170, 3)
fill(home / "Library/Caches/Homebrew", 110, 20)
fill(home / ".cache/uv", 60, 30)
fill(home / ".ollama/models", 260, 45)

for name, megabytes, days in [("com.tinyspeck.slackmacgap", 90, 1), ("com.spotify.client", 75, 2), ("com.figma.Desktop", 40, 4)]:
    fill(home / "Library/Caches" / name, megabytes, days)
fill(home / "Library/Logs/DiagnosticReports", 8, 3)
print(f"demo home ready: {home}")
