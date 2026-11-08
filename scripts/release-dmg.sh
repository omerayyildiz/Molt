#!/bin/bash
# Builds the free direct download: archive, Developer ID export, DMG with an Applications shortcut,
# notarization, and optionally a GitHub release that the website's Download button points to.
#
# Usage:
#   scripts/release-dmg.sh             Signed and notarized DMG in build/release/Molt.dmg
#   scripts/release-dmg.sh --publish   The same, then uploaded to a GitHub release named v<version>
#   scripts/release-dmg.sh --dev       Development-signed DMG to try the steps, without Developer ID or notarization
#
# Needs once: a "Developer ID Application" certificate (Xcode > Settings > Accounts > Manage Certificates)
# and notarization credentials saved with:
#   xcrun notarytool store-credentials molt-notary --apple-id <apple id> --team-id HK444AFW4Q
set -euo pipefail
cd "$(dirname "$0")/.."

MODE="release"
PUBLISH=false
for argument in "$@"; do
    case "$argument" in
        --dev) MODE="dev" ;;
        --publish) PUBLISH=true ;;
        *) echo "Unknown option: $argument" >&2; exit 1 ;;
    esac
done

BUILD="build/release"
NOTARY_PROFILE="${NOTARY_PROFILE:-molt-notary}"
VERSION=$(xcodebuild -project Molt.xcodeproj -scheme Molt -showBuildSettings 2>/dev/null | awk '$1 == "MARKETING_VERSION" { print $3; exit }')
# Build numbers only have to grow; the time does that without a counter in the repository.
BUILD_NUMBER=$(date +%Y%m%d%H%M)

echo "Molt $VERSION ($BUILD_NUMBER), $MODE"
[ ! -e /Volumes/Molt ] || { echo "Eject the mounted Molt disk first." >&2; exit 1; }
rm -rf "$BUILD"
mkdir -p "$BUILD"

xcodebuild -project Molt.xcodeproj -scheme Molt -configuration Release \
    -archivePath "$BUILD/Molt.xcarchive" CURRENT_PROJECT_VERSION="$BUILD_NUMBER" archive -quiet

if [ "$MODE" = "release" ]; then
    xcodebuild -exportArchive -archivePath "$BUILD/Molt.xcarchive" \
        -exportOptionsPlist scripts/ExportOptions-DeveloperID.plist -exportPath "$BUILD/export" \
        -allowProvisioningUpdates -quiet
    APP="$BUILD/export/Molt.app"
else
    APP="$BUILD/Molt.xcarchive/Products/Applications/Molt.app"
fi

STAGE="$BUILD/dmg"
mkdir -p "$STAGE/.background"
cp -R "$APP" "$STAGE/"
ln -s /Applications "$STAGE/Applications"
cp scripts/dmg-background.tiff "$STAGE/.background/background.tiff"
# Finder can only save the window's layout on a writable image, so the DMG starts as one.
hdiutil create -volname "Molt" -srcfolder "$STAGE" -fs HFS+ -format UDRW -size "$(( $(du -sm "$STAGE" | cut -f1) + 20 ))m" -ov -quiet "$BUILD/Molt-rw.dmg"
hdiutil attach "$BUILD/Molt-rw.dmg" -readwrite -noverify -noautoopen -quiet
osascript scripts/dmg-layout.applescript
rm -rf /Volumes/Molt/.fseventsd
sync
hdiutil detach /Volumes/Molt -quiet
hdiutil convert "$BUILD/Molt-rw.dmg" -format UDZO -ov -quiet -o "$BUILD/Molt.dmg"
rm "$BUILD/Molt-rw.dmg"

if [ "$MODE" = "release" ]; then
    codesign --sign "Developer ID Application" --timestamp "$BUILD/Molt.dmg"
    xcrun notarytool submit "$BUILD/Molt.dmg" --keychain-profile "$NOTARY_PROFILE" --wait
    xcrun stapler staple "$BUILD/Molt.dmg"
    spctl --assess --type open --context context:primary-signature --verbose "$BUILD/Molt.dmg"
fi

echo "DMG: $BUILD/Molt.dmg ($(du -h "$BUILD/Molt.dmg" | cut -f1))"

if [ "$PUBLISH" = true ]; then
    [ "$MODE" = "release" ] || { echo "Only notarized DMGs are published." >&2; exit 1; }
    # The asset keeps the same name in every release, so releases/latest/download/Molt.dmg always works.
    NOTES="docs/releases/v$VERSION.md"
    [ -f "$NOTES" ] || { echo "Write the release notes in $NOTES first." >&2; exit 1; }
    gh release create "v$VERSION" "$BUILD/Molt.dmg" --title "Molt $VERSION" --notes-file "$NOTES"
fi
