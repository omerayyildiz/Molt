import Foundation

/// One kind of rebuildable file Molt knows, where to find it and how safe it is to remove.
/// Molt removes only what a rule describes; everything else is left alone.
nonisolated struct Rule: Identifiable, Sendable {
    /// A stable id such as `xcode.derived-data`. History and the protect list refer to it.
    let id: String
    let category: Category
    let name: LocalizedStringResource
    /// What the files are, in one sentence.
    let summary: LocalizedStringResource
    /// How the files come back after they are removed.
    let recovery: LocalizedStringResource
    let trust: Trust
    let locator: Locator
}

/// Where a rule's items are. Paths are relative to the home folder.
nonisolated enum Locator: Sendable {
    /// Each folder is one item.
    case folders([String])
    /// Each entry inside the folder is one item (one DerivedData folder, one device backup).
    /// Entries whose names start with a prefix in `skipping` are left out.
    case contents(of: String, skipping: [String] = [])
    /// A folder named `folder` next to one of the `markers` (`node_modules` next to `package.json`),
    /// in any project under the scanned roots. The marker proves which tool made the folder.
    case projectArtifact(folder: String, markers: [String])

    /// The paths this locator owns, so `contents(of:)` of a parent folder does not list them a second time.
    var claimedPaths: [String] {
        switch self {
        case .folders(let paths): paths
        case .contents(let path, _): [path]
        case .projectArtifact: []
        }
    }
}
