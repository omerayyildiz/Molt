# Molt

A Mac app that frees the space developers lose to rebuildable files: `node_modules`, Xcode's Derived Data, simulator
caches, package manager caches, old iOS installers, local AI models and app caches.

Molt removes only what it can explain. Every item says what it is, how safe it is to remove and how it comes back.

> Status: early skeleton (v0.1 in progress). Not ready for daily use.

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

Nothing is checked until you check it. Molt never asks for an administrator password, never leaves your home folder
and does not use the network.

## Editions

| | Direct download | Mac App Store |
|---|---|---|
| Price | Free | A small price that supports the project |
| Sandbox | No | Yes |
| Covers | Every rule | Rules that only need files; asks once for your home folder |

The App Store sandbox cannot run tools such as `xcrun simctl` or `docker`, so rules that need them are only in the
direct download. Both are built from this repository.

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

## Contributing

New cleanup rules are the most useful contribution. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Molt is free software under the [GNU General Public License v3.0](LICENSE). The name "Molt" and the app icon are not
covered by the license; forks need their own name and icon.
