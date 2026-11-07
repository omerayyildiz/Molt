#!/bin/bash
# Saves Molt's screens in dark and light, English and Turkish, from a made-up home folder.
# Output: build/screenshots/<appearance>-<language>/*.png at Retina size (2000 x 1280 for the main window).
#
# Usage: scripts/screenshots.sh
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="build/screenshots"
DEMO="$(mktemp -d)/home"
trap 'rm -rf "$(dirname "$DEMO")"' EXIT

python3 -I scripts/make-demo-home.py "$DEMO"
xcodebuild -project Molt.xcodeproj -scheme Molt -configuration Debug -derivedDataPath build/screenshots-dd build -quiet
APP="build/screenshots-dd/Build/Products/Debug/Molt.app/Contents/MacOS/Molt"

for appearance in dark light; do
    for language in en tr; do
        folder="$OUT/$appearance-$language"
        rm -rf "$folder"
        arguments=(-screenshotFolder "$PWD/$folder" -demoHome "$DEMO" -AppleLanguages "($language)" -NSQuitAlwaysKeepsWindows NO)
        [ "$appearance" = light ] && arguments+=(-NSRequiresAquaSystemAppearance YES)
        "$APP" "${arguments[@]}"
        python3 -I scripts/activate-windows.py "$folder" > /dev/null
        echo "$folder: $(ls "$folder" | wc -l | tr -d ' ') screens"
    done
done
