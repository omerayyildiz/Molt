import Foundation

/// What every cleanup removed and how much space it freed, kept in `history.json`.
nonisolated struct CleanupHistory: Sendable {
    struct Entry: Codable, Sendable, Equatable {
        let date: Date
        let ruleID: String
        let path: String
        let bytes: Int64
    }

    private let file: JSONFile<[Entry]>

    init(file: URL = MoltLocations.supportFolder.appending(path: "history.json")) {
        self.file = JSONFile(url: file)
    }

    func load() -> [Entry] { file.read() ?? [] }

    /// Everything Molt has freed on this Mac.
    func totalFreed() -> Int64 { load().reduce(0) { $0 + $1.bytes } }

    func append(_ entries: [Entry]) throws {
        guard !entries.isEmpty else { return }
        try file.write(load() + entries)
    }
}
