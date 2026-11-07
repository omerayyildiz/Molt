# Molt

An open source Mac app that removes rebuildable files developers accumulate (`node_modules`, Xcode Derived Data,
simulator and package manager caches, old iOS installers, local AI models, app caches). GPL-3.0. Shipped two ways
from one codebase: a free direct download (Developer ID, no sandbox) and a paid Mac App Store build (sandbox).

## Principles

- Molt removes only what a rule describes. Everything else is read at most, never changed.
- Show first, remove after: a scan changes nothing, nothing is checked until the user checks it, and every
  cleanup goes through a confirmation.
- Trust decides removal (`Trust.removal`): safe and caution items are deleted (the Trash would free no space),
  risky items go to the Trash.
- `SafeRemover` checks every item again right before removal: it still exists, is not a symbolic link, resolves
  inside the home folder, is not and does not contain a protected folder, and has the same file number as at
  scan time.
- Never `sudo`, never outside the home folder, no network, no analytics.
- Tools own their data: simulators through `xcrun simctl`, Docker through `docker`, Homebrew through `brew`.
  Never touch those files by hand. Tool rules are not built yet; they will exist only in the direct build.

## Two Builds

| Target | Sandbox | Flag | Notes |
|---|---|---|---|
| Molt | No | none | Every rule |
| Molt App Store | Yes (`MoltAppStore.entitlements`) | `APP_STORE` | Asks once for the home folder (`HomeFolderAccess`, security-scoped bookmark) |

- Both targets compile the same `Molt` folder. Put build-specific code behind `#if APP_STORE`.
- `MoltLocations.home` is the real home folder (`getpwuid`); in the sandbox `URL.homeDirectory` is the container.
- `~/Library/Application Support/MobileSync/Backup` (device backups) is protected by macOS. Reading it needs Full
  Disk Access in the direct build; in the sandbox it may not be reachable at all. Not solved yet.

## Architecture

```
Molt/
  MoltApp.swift, ContentView.swift   Scene, window, clean bar and confirmation
  Models/     Rule, Locator, Trust, Category, CleanupItem (plain value types)
  Rules/      RuleCatalog and one file per group of rules (Swift code, not JSON)
  Services/   Scanner, DiskUsage, SafeRemover, CleanupHistory, PathList, VolumeUsage, MoltLocations (UI-free);
              HomeFolderAccess (AppKit, App Store build only)
  Store/      AppModel: the single source of truth (@Observable, @MainActor)
  Views/      SwiftUI views
  Support/    Foundation extensions, JSONFile
  Localizable.xcstrings   English and Turkish
MoltAppStore.entitlements
```

- Same conventions as ClaudeDeck: views get `let model: AppModel`, never `.environment`; confirmations live on
  `ContentView`; models and services are `nonisolated` and `Sendable`; heavy work runs in `@concurrent` functions;
  Swift 6 with `MainActor` default isolation; macOS 15 minimum.
- The window: sidebar with Overview (`DiskOverview`, the disk bar like System Settings > Storage, from
  `VolumeUsage`, plus the total freed from the history) and one page per category (`ItemList`: trust and age
  filters, Check All, sortable Size and Last Changed, Finder-style row selection with Space and a context menu).
  Settings holds Project Folders and the Never Suggested list (both `PathList` JSON files).
- Layout lessons: `CleanBar` sits below the content in a `VStack`, never as an overlay or `safeAreaInset` (the
  table does not inset for it and the last rows were hidden). Every page fills the height, including empty
  states, or the header and bar float mid-window. Never put `fixedSize(vertical:)` on wrapping text in the
  window: it made the window grow to 1487 points.
- Mascot: Molt the hermit crab (`Mascot`, images `Mascot*` in the asset catalog) appears while a category
  scans, when it is empty, in the clean bar while cleaning, and in `CleanupDoneCard` after a cleanup (closes
  itself after 8 seconds). It is decorative and hidden from VoiceOver; the text beside it carries the meaning.
  The app icon is the same crab's head on an ocean blue rounded square (Apple's 824-in-1024 grid).
- Accessibility: checkboxes carry the rule name, rows combine their text, decorative icons are hidden, the disk
  bar has a label and value, animations go through `motion(_:value:)` so Reduce Motion stops them.
  Shortcuts: ⌘R scan, ⌘⌫ clean, ⇧⌘A check all safe items, Space checks selected rows.
- `AppModel.scan` scans every category in parallel and shows each as it finishes (`scanningCategories`).
  `scan(_:among:)` keeps claimed paths from the whole catalog. Cleaning removes items from the list one by one
  instead of scanning again.
- `Scanner` walks the project roots once for all project rules, never enters artifact folders, hidden folders,
  `~/Library`, the Trash or `MoltLocations.privacyProtectedFolders` (Desktop, Documents, Downloads, Movies,
  Music, Pictures), and stops at `projectDepth`. Entering those folders makes macOS show one permission prompt
  each and the scan waits for the answers (measured: first scan 18.5 s with prompts, 0.17 s without). Users add
  folders there in Settings > Project Folders. Found folders are measured in parallel.
- Scan timing is logged per category (subsystem `miedinger.Molt`, category `scan`, level notice). Read it with
  `/usr/bin/log show --last 5m --predicate 'subsystem == "miedinger.Molt"'` (zsh has its own `log` builtin).
- A `contents(of:)` rule skips entries another rule claims (`Locator.claimedPaths`), so `Library/Caches/Homebrew`
  is listed under Homebrew, not twice.
- The project file is hand-written with file system synchronized groups; new files in `Molt/` join both targets.

## Release

| Task | How |
|---|---|
| Free DMG | `scripts/release-dmg.sh` (archive, Developer ID export, DMG, notarization; `--publish` makes the GitHub release, `--dev` tries the steps without signing). The asset is always `Molt.dmg`, so `releases/latest/download/Molt.dmg` works. |
| App Store | `scripts/upload-app-store.sh`; texts and review notes in `docs/app-store/metadata.md` |
| Screenshots | `scripts/screenshots.sh` (Debug build, `ScreenshotTour`, made-up home from `scripts/make-demo-home.py`), then `scripts/frame-images.py` (README and website) and `scripts/app-store-art.swift` |
| Website | `website/` (static, Vercel project `miedinger/molt`, domain molt.omerayyildiz.com). The Download link is `DOWNLOAD_URL` in `website/main.js`. |

- Version in `MARKETING_VERSION`; build numbers come from the date at archive time.
- Both targets are named Molt (menus, About, the installed app); the App Store build goes to `<Configuration>-AppStore`.
- `Molt-Info.plist` adds `ITSAppUsesNonExemptEncryption = NO`; `Molt/PrivacyInfo.xcprivacy` declares no tracking and
  the reasons for file dates, disk space and UserDefaults.
- The sandboxed build sees far fewer app caches than the direct one (measured: 3 of 18), because the sandbox hides
  most other apps' caches even inside the granted home folder. It never asks for Full Disk Access.
- The Dock icon style (Settings) is applied at launch with `NSApp.applicationIconImage`; macOS has no alternate app
  icons, so Finder keeps the ocean icon.
- `ScreenshotTour` and `-demoHome` exist only in Debug builds. Bitmaps of the window cannot draw frosted glass, so
  the tour hides the sidebar and the cleanup card uses a solid background.

## Tests

```bash
swift test --scratch-path "$TMPDIR/molt-build"
```

- `Package.swift` builds `Models`, `Rules`, `Services` and `Support` as `MoltCore` (without the AppKit and SwiftUI
  files) with the app's settings. Tests use Swift Testing against a fake home folder (`TemporaryHome`).
- Every rule, and any change to scanning or removal, comes with a test.
- `--scratch-path` keeps build output out of the repo (and out of iCloud if the repo ever moves there).

## Rules

- UI text in English and Turkish, title case for buttons and menu items. Code, comments and docs in English.
- Rule ids are stable; history refers to them.
- No third-party dependencies (Sparkle for the direct build's updates is the one open question).
- Do not write the same logic twice; move shared parts into a service or a small view.
