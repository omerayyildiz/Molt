<p align="center">
  <img src="docs/images/icon.png" width="128" height="128" alt="Molt app icon">
</p>

<h1 align="center">Molt</h1>

<p align="center">
  <strong>Shed what your Mac no longer needs.</strong><br>
  A free, open source Mac app that clears the space developers lose to rebuildable files.
</p>

<p align="center">
  <a href="https://github.com/omerayyildiz/Molt/releases/latest/download/Molt.dmg"><img src="https://img.shields.io/badge/Download-Molt.dmg-3B2F9E?style=for-the-badge&logo=apple&logoColor=white" alt="Download Molt.dmg"></a>
  <a href="https://molt.omerayyildiz.com"><img src="https://img.shields.io/badge/Website-molt.omerayyildiz.com-3DDBB0?style=for-the-badge" alt="Website"></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-15%2B-555?logo=apple" alt="macOS 15 or later">
  <img src="https://img.shields.io/badge/license-GPL--3.0-555" alt="GPL-3.0">
  <img src="https://img.shields.io/badge/no%20tracking-no%20network-555" alt="No tracking, no network">
</p>

<p align="center">
  <img src="docs/images/mascot.png" width="420" alt="Molt the hermit crab leaving its old shell, full of boxes, for a light new one">
</p>

`node_modules`, Xcode build data, package caches and AI models pile up quietly, and macOS files them under
System Data. Molt finds them, explains each one and removes only what you choose.

![Molt's overview: the disk split by category, like System Settings](docs/images/overview.png)

## Why Molt

- **Explains every item.** What it is, how safe it is to remove, and how it comes back. Nothing is checked until you
  check it.
- **Only rebuildable files.** Molt knows a fixed list of cleanup rules and touches nothing else: no documents, photos,
  settings, mail or iCloud files.
- **Safe by design.** Every item is checked again right before removal. Files that do not come back go to the Trash.
  Molt never asks for an administrator password and never leaves your home folder.
- **Private.** No account, no analytics, no network access.
- **Open source.** Every rule is readable Swift code in [`Molt/Rules`](Molt/Rules).

![Project folders with trust levels, last changed dates and sizes](docs/images/projects.png)

## What Molt Cleans

| Group | Examples | Trust |
|---|---|---|
| Xcode | Derived Data, SwiftUI previews, device support, archives | Safe to risky |
| Simulators | Simulator caches | Safe |
| iPhone and iPad | Old iOS installers, device backups | Safe / risky |
| Projects | `node_modules`, `.next`, `target`, `.build`, `Pods`, `.venv`, Gradle `build` | Safe / caution |
| Package managers | npm, npx, Yarn, pnpm, Bun, Homebrew, pip, uv, Cargo, Gradle, CocoaPods | Safe |
| AI models | Ollama, LM Studio, Hugging Face | Caution |
| App caches and logs | `~/Library/Caches`, `~/Library/Logs` | Safe |

- **Safe:** comes back by itself or with the next build. Deleted.
- **Caution:** comes back by downloading or installing it again. Deleted.
- **Risky:** does not come back. Moved to the Trash, never deleted.

Projects in Desktop, Documents and Downloads are searched only after you add them in Settings, so macOS never surprises
you with permission prompts.

![After a cleanup, Molt shows how much space came back](docs/images/done.png)

## Download

| | Direct download | Mac App Store |
|---|---|---|
| Price | Free | $2.99, to support the project |
| Sandbox | No | Yes |
| Covers | Every rule | Rules that only need files; asks once for your home folder |

**[Download Molt.dmg](https://github.com/omerayyildiz/Molt/releases/latest/download/Molt.dmg)**, open it and drag
Molt to Applications.

The App Store version runs in Apple's sandbox, which hides most other apps' caches and cannot run tools such as
`xcrun simctl`. Buying it is a way to support Molt; the free download does more.

## Building

Requirements: Xcode 27 or later to build. The app runs on macOS 15 or later.

```bash
open Molt.xcodeproj
```

Choose the **Molt** scheme for the direct build or **Molt App Store** for the sandboxed one.

Run the tests (they never launch the app or touch your real home folder):

```bash
swift test --scratch-path "$TMPDIR/molt-build"
```

Release tools live in [`scripts`](scripts): `release-dmg.sh` builds, notarizes and publishes the DMG,
`upload-app-store.sh` sends the App Store build to App Store Connect, `screenshots.sh` saves the screens above
from a made-up home folder, and `frame-images.py` frames them for this page and the website.

## Contributing

New cleanup rules are the most useful contribution. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Molt is free software under the [GNU General Public License v3.0](LICENSE). The name "Molt", the app icon and the
hermit crab mascot are not covered by the license; forks need their own name and artwork.
