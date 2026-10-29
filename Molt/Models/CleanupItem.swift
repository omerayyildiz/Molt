import Foundation

/// A file or folder found by a scan.
nonisolated struct CleanupItem: Identifiable, Sendable, Hashable {
    let ruleID: String
    let url: URL
    /// Bytes on disk, everything inside a folder included.
    let size: Int64
    /// For project files, when the project was last changed; otherwise when the item was.
    let lastModified: Date?
    /// The file system's number for the item, checked again right before removal so a folder replaced
    /// since the scan is never removed.
    let fileNumber: UInt64?

    var id: URL { url }

    /// For sorting: items without a date sort as the oldest.
    var sortDate: Date { lastModified ?? .distantPast }
}

nonisolated extension Sequence<CleanupItem> {
    var totalSize: Int64 { reduce(0) { $0 + $1.size } }
}
