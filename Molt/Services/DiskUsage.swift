import Foundation

nonisolated enum DiskUsage {
    private static let keys: Set<URLResourceKey> = [.totalFileAllocatedSizeKey, .isDirectoryKey]

    /// Bytes the item takes on disk, everything inside a folder included. Symbolic links are not followed.
    /// Hard links (pnpm uses them) are counted once per link, so the figure can be higher than the space freed.
    static func allocatedSize(of url: URL) -> Int64 {
        guard let values = try? url.resourceValues(forKeys: keys) else { return 0 }
        guard values.isDirectory == true else { return Int64(values.totalFileAllocatedSize ?? 0) }
        guard let walker = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: Array(keys),
            errorHandler: { _, _ in true }
        ) else { return 0 }

        var total: Int64 = 0
        for case let file as URL in walker {
            total += Int64((try? file.resourceValues(forKeys: keys))?.totalFileAllocatedSize ?? 0)
        }
        return total
    }
}

nonisolated enum FileIdentity {
    /// The file system's number for the item (its inode), which changes when the item is replaced.
    static func number(of url: URL) -> UInt64? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.plainPath)
        return (attributes?[.systemFileNumber] as? NSNumber)?.uint64Value
    }
}
