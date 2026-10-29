import Foundation

/// Removes scanned items after checking them once more. Never uses `sudo` and never leaves the home folder.
nonisolated enum SafeRemover {
    enum Failure: Error, Equatable {
        case missing
        case symbolicLink
        case outsideHome
        case protected
        case changedSinceScan
    }

    /// Folders, relative to the home folder, that are never removed, nor anything that contains them.
    /// Items inside them (one cache in `Library/Caches`) can be.
    static let protectedPaths = [
        "Desktop", "Documents", "Downloads", "Movies", "Music", "Pictures", "Public",
        "Library", "Library/Application Support", "Library/CloudStorage", "Library/Containers",
        "Library/Developer", "Library/Group Containers", "Library/Keychains", "Library/Mail",
        "Library/Messages", "Library/Mobile Documents", "Library/Preferences",
        ".config", ".ssh",
    ]

    static func check(_ item: CleanupItem, home: URL) throws(Failure) {
        let url = item.url
        guard let values = try? url.resourceValues(forKeys: [.isSymbolicLinkKey]) else { throw .missing }
        if values.isSymbolicLink == true { throw .symbolicLink }

        // Resolved, so a symbolic link in a parent folder cannot lead outside the home folder.
        let resolvedHome = home.resolvingSymlinksInPath()
        let resolved = url.resolvingSymlinksInPath()
        guard resolved.isInside(resolvedHome), resolved.plainPath != resolvedHome.plainPath else { throw .outsideHome }
        if protectedPaths.contains(where: { resolvedHome.appending(path: $0).isInside(resolved) }) { throw .protected }

        if FileIdentity.number(of: url) != item.fileNumber { throw .changedSinceScan }
    }

    @concurrent static func remove(_ item: CleanupItem, trust: Trust, home: URL) async throws {
        try check(item, home: home)
        switch trust.removal {
        case .delete: try FileManager.default.removeItem(at: item.url)
        case .moveToTrash: try FileManager.default.trashItem(at: item.url, resultingItemURL: nil)
        }
    }
}
