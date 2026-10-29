import Foundation

/// A list of folders the user chose, kept as JSON in Molt's support folder.
nonisolated struct PathList: Sendable {
    private let file: JSONFile<[String]>

    init(file: URL) {
        self.file = JSONFile(url: file)
    }

    /// Folders Molt was asked never to suggest again. Protecting a folder also hides everything inside it.
    static var protected: PathList { PathList(file: MoltLocations.supportFolder.appending(path: "protected.json")) }

    /// Folders searched for projects on top of the home folder, such as `~/Documents/Code`.
    static var projectFolders: PathList { PathList(file: MoltLocations.supportFolder.appending(path: "project-folders.json")) }

    func load() -> [String] { file.read() ?? [] }

    func save(_ paths: [String]) throws { try file.write(Array(Set(paths)).sorted()) }

    /// Whether `url` is one of `paths` or inside one of them.
    static func contains(_ url: URL, in paths: [String]) -> Bool {
        paths.contains { url.isInside(URL(filePath: $0, directoryHint: .isDirectory)) }
    }
}
