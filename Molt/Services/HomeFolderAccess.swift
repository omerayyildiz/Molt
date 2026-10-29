import AppKit

/// The App Store build runs in the sandbox and can read only folders the user picked. Molt asks for the
/// home folder once and keeps a security-scoped bookmark to it. The direct build never needs this.
enum HomeFolderAccess {
    private static let bookmarkKey = "homeFolderBookmark"

    /// The home folder with access started, asking the user to pick it the first time.
    static func start() -> URL? {
        if let url = bookmarkedHome(), url.startAccessingSecurityScopedResource() { return url }

        let panel = NSOpenPanel()
        panel.message = String(localized: "Molt needs your home folder to find caches and build files. Choose your home folder and click Allow.")
        panel.prompt = String(localized: "Allow")
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.directoryURL = MoltLocations.home
        guard panel.runModal() == .OK, let url = panel.url else { return nil }

        if let bookmark = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) {
            UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        }
        // A folder picked in the panel is readable for this session even without the bookmark.
        _ = url.startAccessingSecurityScopedResource()
        return url
    }

    private static func bookmarkedHome() -> URL? {
        guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else { return nil }
        var isStale = false
        return try? URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
    }
}
