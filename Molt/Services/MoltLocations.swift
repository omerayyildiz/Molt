import Foundation

nonisolated enum MoltLocations {
    /// The user's real home folder. In the App Store build's sandbox `URL.homeDirectory` is the app's container.
    static var home: URL {
        #if DEBUG
        // `-demoHome <folder>` scans a made-up home folder, for screenshots that show no one's real files.
        if let demo = UserDefaults.standard.string(forKey: "demoHome") {
            return URL(filePath: demo, directoryHint: .isDirectory)
        }
        #endif
        guard let directory = getpwuid(getuid())?.pointee.pw_dir else { return .homeDirectory }
        return URL(filePath: String(cString: directory), directoryHint: .isDirectory)
    }

    /// Molt's own files. Inside the sandbox this resolves to the app's container.
    static var supportFolder: URL {
        .applicationSupportDirectory.appending(path: "Molt", directoryHint: .isDirectory)
    }

    /// Home folders macOS asks permission for, one prompt each. The project search skips them unless the user
    /// adds one (or a folder inside one) as a project folder, so a scan never surprises with prompts.
    static let privacyProtectedFolders = ["Desktop", "Documents", "Downloads", "Movies", "Music", "Pictures"]

    /// Where Finder keeps iPhone and iPad backups. macOS lets only apps with Full Disk Access read it.
    static func deviceBackups(in home: URL) -> URL {
        home.appending(path: "Library/Application Support/MobileSync/Backup", directoryHint: .isDirectory)
    }

    /// Whether the folder exists but its contents cannot be listed, which is how a missing Full Disk Access
    /// permission shows.
    static func isUnreadable(_ folder: URL) -> Bool {
        FileManager.default.fileExists(atPath: folder.plainPath)
            && (try? FileManager.default.contentsOfDirectory(atPath: folder.plainPath)) == nil
    }
}
