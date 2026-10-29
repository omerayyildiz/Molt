import Foundation
import Testing
@testable import MoltCore

struct SafeRemoverTests {
    private func scanned(_ url: URL) -> CleanupItem {
        CleanupItem(ruleID: "test", url: url, size: 1, lastModified: nil, fileNumber: FileIdentity.number(of: url))
    }

    @Test func deletesASafeItem() async throws {
        let home = try TemporaryHome()
        let folder = try home.write(to: ".npm/_cacache/index").deletingLastPathComponent()

        try await SafeRemover.remove(scanned(folder), trust: .safe, home: home.url)

        #expect(!home.exists(".npm/_cacache"))
        #expect(home.exists(".npm"))
    }

    @Test func refusesAnItemReplacedSinceTheScan() throws {
        let home = try TemporaryHome()
        let folder = try home.write(to: "Library/Caches/App/old").deletingLastPathComponent()
        let item = scanned(folder)
        try FileManager.default.removeItem(at: folder)
        try home.write(to: "Library/Caches/App/new")

        #expect(throws: SafeRemover.Failure.changedSinceScan) { try SafeRemover.check(item, home: home.url) }
    }

    @Test func refusesSymbolicLinks() throws {
        let home = try TemporaryHome()
        let target = try home.write(to: "Documents/thesis.txt").deletingLastPathComponent()
        let link = home.url.appending(path: "Library/Caches/Link")
        try FileManager.default.createDirectory(at: link.deletingLastPathComponent(), withIntermediateDirectories: true)
        try FileManager.default.createSymbolicLink(at: link, withDestinationURL: target)

        #expect(throws: SafeRemover.Failure.symbolicLink) { try SafeRemover.check(scanned(link), home: home.url) }
    }

    @Test func refusesProtectedFoldersAndTheirParents() throws {
        let home = try TemporaryHome()
        for path in ["Documents", "Library", "Library/Application Support"] {
            let folder = try home.write(to: "\(path)/file").deletingLastPathComponent()
            #expect(throws: SafeRemover.Failure.protected) { try SafeRemover.check(scanned(folder), home: home.url) }
        }
        #expect(throws: SafeRemover.Failure.outsideHome) { try SafeRemover.check(scanned(home.url), home: home.url) }
    }

    @Test func refusesItemsOutsideTheHomeFolder() throws {
        let home = try TemporaryHome()
        let elsewhere = try TemporaryHome()
        let folder = try elsewhere.write(to: "Caches/file").deletingLastPathComponent()

        #expect(throws: SafeRemover.Failure.outsideHome) { try SafeRemover.check(scanned(folder), home: home.url) }
    }

    @Test func historyAppendsEntries() throws {
        let home = try TemporaryHome()
        let history = CleanupHistory(file: home.url.appending(path: "Molt/history.json"))
        let entry = CleanupHistory.Entry(date: Date(timeIntervalSince1970: 0), ruleID: "packages.npm", path: "~/.npm/_cacache", bytes: 42)

        try history.append([entry])
        try history.append([entry])

        #expect(history.load() == [entry, entry])
    }
}
