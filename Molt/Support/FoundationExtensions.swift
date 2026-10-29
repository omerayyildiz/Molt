import Foundation

nonisolated extension URL {
    /// The file system path without percent encoding or a trailing slash.
    var plainPath: String {
        let path = standardizedFileURL.path(percentEncoded: false)
        return path.count > 1 && path.hasSuffix("/") ? String(path.dropLast()) : path
    }

    /// The path with the home folder shortened to `~`.
    var displayPath: String {
        let home = MoltLocations.home.plainPath
        return plainPath.hasPrefix(home) ? "~" + plainPath.dropFirst(home.count) : plainPath
    }

    func resourceValue<Value>(_ keyPath: KeyPath<URLResourceValues, Value?>, for key: URLResourceKey) -> Value? {
        (try? resourceValues(forKeys: [key]))?[keyPath: keyPath]
    }

    /// Whether this URL is `ancestor` itself or inside it.
    func isInside(_ ancestor: URL) -> Bool {
        let path = plainPath, base = ancestor.plainPath
        return path == base || path.hasPrefix(base == "/" ? "/" : base + "/")
    }
}

nonisolated extension Int64 {
    /// A byte count the way Finder shows file sizes ("1,2 GB").
    var fileSize: String { formatted(.byteCount(style: .file)) }
}
