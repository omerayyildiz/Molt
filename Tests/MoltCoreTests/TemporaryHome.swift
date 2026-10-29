import Foundation

/// A fake home folder removed when the test ends. Symlinks are resolved so paths compare like real ones.
final class TemporaryHome {
    let url: URL

    init() throws {
        url = FileManager.default.temporaryDirectory
            .appending(path: "MoltTests-\(UUID().uuidString)", directoryHint: .isDirectory)
            .resolvingSymlinksInPath()
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    deinit {
        try? FileManager.default.removeItem(at: url)
    }

    @discardableResult
    func write(_ text: String = "data", to relativePath: String) throws -> URL {
        let file = url.appending(path: relativePath)
        try FileManager.default.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
        try text.write(to: file, atomically: true, encoding: .utf8)
        return file
    }

    func exists(_ relativePath: String) -> Bool {
        FileManager.default.fileExists(atPath: url.appending(path: relativePath).path(percentEncoded: false))
    }
}
