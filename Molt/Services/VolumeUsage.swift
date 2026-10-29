import Foundation

/// How full the disk is, measured the way System Settings > Storage measures it.
nonisolated struct VolumeUsage: Sendable, Equatable {
    let name: String
    let total: Int64
    /// Free space plus space macOS can purge on demand (local snapshots, caches it manages).
    let available: Int64

    var used: Int64 { max(total - available, 0) }

    /// The volume that holds `url`, usually the startup disk for the home folder.
    static func of(_ url: URL = MoltLocations.home) -> VolumeUsage? {
        let keys: Set<URLResourceKey> = [
            .volumeLocalizedNameKey, .volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey,
        ]
        guard let values = try? url.resourceValues(forKeys: keys),
              let total = values.volumeTotalCapacity,
              let available = values.volumeAvailableCapacityForImportantUsage
        else { return nil }
        return VolumeUsage(name: values.volumeLocalizedName ?? "", total: Int64(total), available: available)
    }
}
