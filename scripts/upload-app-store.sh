#!/bin/bash
# Archives the sandboxed App Store build and uploads it to App Store Connect, where it can be sent to review.
#
# Usage: scripts/upload-app-store.sh
#
# Needs once: the Apple account signed in to Xcode (Settings > Accounts) and an app record in App Store
# Connect with the bundle ID miedinger.Molt. Xcode creates the Apple Distribution certificate if missing.
set -euo pipefail
cd "$(dirname "$0")/.."

BUILD="build/app-store"
BUILD_NUMBER=$(date +%Y%m%d%H%M)
rm -rf "$BUILD"
mkdir -p "$BUILD"

xcodebuild -project Molt.xcodeproj -scheme "Molt App Store" -configuration Release \
    -archivePath "$BUILD/Molt.xcarchive" CURRENT_PROJECT_VERSION="$BUILD_NUMBER" archive -quiet

xcodebuild -exportArchive -archivePath "$BUILD/Molt.xcarchive" \
    -exportOptionsPlist scripts/ExportOptions-AppStore.plist -exportPath "$BUILD/export" \
    -allowProvisioningUpdates

echo "Uploaded build $BUILD_NUMBER. It shows up in App Store Connect > TestFlight after processing."
