import AppKit

/// The App Store build runs in the sandbox and can read only folders the user picked. Molt asks for the
/// home folder once and keeps a security-scoped bookmark to it. The direct build never needs this.
enum HomeFolderAccess {
    private static let bookmarkKey = "homeFolderBookmark"

    /// The home folder with access started, asking the user to pick it the first time. Any other folder is
    /// refused: every rule's path is relative to the home folder.
    static func start() -> URL? {
        let home = MoltLocations.home
        if let url = bookmarkedHome(), url.plainPath == home.plainPath, url.startAccessingSecurityScopedResource() {
            return url
        }

        let panel = NSOpenPanel()
        panel.message = String(localized: "Molt needs your home folder to find caches and build files. Choose your home folder and click Allow.")
        panel.prompt = String(localized: "Allow")
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = false
        panel.directoryURL = home
        guard panel.runModal() == .OK, let url = panel.url, url.plainPath == home.plainPath else { return nil }

        save(url)
        // A folder picked in the panel is readable for this session even without the bookmark.
        _ = url.startAccessingSecurityScopedResource()
        return url
    }

    private static func bookmarkedHome() -> URL? {
        guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else { return nil }
        var isStale = false
        guard let url = try? URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        else { return nil }
        if isStale { save(url) }
        return url
    }

    private static func save(_ url: URL) {
        if let bookmark = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) {
            UserDefaults.standard.set(bookmark, forKey: bookmarkKey)
        }
    }
}
