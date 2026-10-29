# Contributing to Molt

## Adding a Rule

Rules live in `Molt/Rules/`, one file per group. A rule says where its items are, what they are, how they come back
and how safe they are to remove:

```swift
Rule(
    id: "projects.node-modules",          // stable, never renamed
    category: .projects,
    name: "node_modules",
    summary: "Packages installed for a JavaScript project.",
    recovery: "Run npm install (or pnpm, yarn, bun) in the project.",
    trust: .caution,
    locator: .projectArtifact(folder: "node_modules", markers: ["package.json"])
)
```

Locators:

- `.folders([...])`: each folder is one item.
- `.contents(of:skipping:)`: each entry inside the folder is one item.
- `.projectArtifact(folder:markers:)`: a folder found next to the file of the tool that made it. A rule for a common
  name such as `build` must always name a marker.

Choosing the trust level:

- `.safe` only if the files come back by themselves or with the next build.
- `.caution` if they come back only by downloading or installing again.
- `.risky` if they do not come back. Risky items go to the Trash.

A pull request with a rule also:

1. Says on which macOS and tool version the path was checked.
2. Adds a test in `Tests/MoltCoreTests` that builds the folder in a fake home and checks the scan finds it.
3. Passes `swift test --scratch-path "$TMPDIR/molt-build"`.

## Contributor Agreement

Molt is published under the GPL and also sold on the Mac App Store by its author. Before your first pull request is
merged you will be asked to agree that your contribution may be distributed in both. The agreement text will be added
here before outside contributions are accepted.
