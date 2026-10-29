import Foundation
import Testing
@testable import MoltCore

struct ScannerTests {
    @Test func findsFolderAndContentsRules() async throws {
        let home = try TemporaryHome()
        try home.write(to: "Library/Developer/Xcode/DerivedData/AppA-abc/Build/file")
        try home.write(to: "Library/Developer/Xcode/DerivedData/AppB-def/Build/file")
        try home.write(to: ".npm/_cacache/index")

        let items = await Scanner(home: home.url).scan(RuleCatalog.all)

        #expect(items.filter { $0.ruleID == "xcode.derived-data" }.map(\.url.lastPathComponent).sorted() == ["AppA-abc", "AppB-def"])
        #expect(items.contains { $0.ruleID == "packages.npm" && $0.size > 0 })
    }

    /// `Library/Caches/Homebrew` belongs to the Homebrew rule; the app cache rule must not list it again.
    @Test func contentsRulesSkipFoldersOtherRulesClaim() async throws {
        let home = try TemporaryHome()
        try home.write(to: "Library/Caches/Homebrew/bottle.tar.gz")
        try home.write(to: "Library/Caches/com.example.App/cache.db")
        try home.write(to: "Library/Caches/com.apple.Safari/cache.db")

        let items = await Scanner(home: home.url).scan(RuleCatalog.all)

        #expect(items.filter { $0.ruleID == "apps.caches" }.map(\.url.lastPathComponent) == ["com.example.App"])
        #expect(items.contains { $0.ruleID == "packages.homebrew" })
    }

    /// The app scans each category on its own; the app cache rule must still skip folders claimed by rules
    /// of other categories.
    @Test func scanningOneCategoryStillSkipsFoldersOtherCategoriesClaim() async throws {
        let home = try TemporaryHome()
        try home.write(to: "Library/Caches/Homebrew/bottle.tar.gz")
        try home.write(to: "Library/Caches/com.example.App/cache.db")
        let appRules = RuleCatalog.all.filter { $0.category == .apps }

        let items = await Scanner(home: home.url).scan(appRules, among: RuleCatalog.all)

        #expect(items.map(\.url.lastPathComponent) == ["com.example.App"])
    }

    @Test func volumeUsageReadsTheDisk() throws {
        let home = try TemporaryHome()
        let volume = try #require(VolumeUsage.of(home.url))

        #expect(volume.total > 0)
        #expect(volume.available > 0 && volume.available <= volume.total)
        #expect(volume.used == volume.total - volume.available)
    }

    @Test func findsProjectArtifactsOnlyNextToTheirMarker() async throws {
        let home = try TemporaryHome()
        try home.write("{}", to: "Code/web/package.json")
        try home.write(to: "Code/web/node_modules/react/index.js")
        try home.write(to: "Code/web/node_modules/react/node_modules/inner/index.js")
        try home.write(to: "Code/stray/node_modules/left/index.js")
        try home.write("[package]", to: "Code/tool/Cargo.toml")
        try home.write(to: "Code/tool/target/debug/tool")
        try home.write(to: "Code/notes/target/plan.txt")

        let items = await Scanner(home: home.url).scan(RuleCatalog.all)
        let found = items.filter { $0.ruleID.hasPrefix("projects.") }.map { $0.url.resolvingSymlinksInPath().plainPath }

        #expect(found.sorted() == [home.url.appending(path: "Code/tool/target").plainPath, home.url.appending(path: "Code/web/node_modules").plainPath])
    }

    /// Walking into Documents or Desktop makes macOS ask for permission, so those are searched only when the
    /// user adds them, and a project reached from two roots is listed once.
    @Test func projectSearchSkipsPrivacyFoldersUnlessAdded() async throws {
        let home = try TemporaryHome()
        try home.write("{}", to: "Documents/Code/app/package.json")
        try home.write(to: "Documents/Code/app/node_modules/a.js")
        try home.write("{}", to: "Code/web/package.json")
        try home.write(to: "Code/web/node_modules/a.js")
        let nodeModules = { (items: [CleanupItem]) in
            items.filter { $0.ruleID == "projects.node-modules" }.map { $0.url.resolvingSymlinksInPath().plainPath }.sorted()
        }

        let homeOnly = await Scanner(home: home.url).scan(RuleCatalog.all)
        let withDocuments = await Scanner(
            home: home.url,
            projectFolders: [home.url.appending(path: "Documents/Code"), home.url.appending(path: "Code")]
        ).scan(RuleCatalog.all)

        #expect(nodeModules(homeOnly) == [home.url.appending(path: "Code/web/node_modules").plainPath])
        #expect(nodeModules(withDocuments) == [
            home.url.appending(path: "Code/web/node_modules").plainPath,
            home.url.appending(path: "Documents/Code/app/node_modules").plainPath,
        ])
    }

    @Test func projectSearchSkipsLibraryAndHiddenFolders() async throws {
        let home = try TemporaryHome()
        try home.write("{}", to: "Library/App/package.json")
        try home.write(to: "Library/App/node_modules/a.js")
        try home.write("{}", to: ".config/yarn/global/package.json")
        try home.write(to: ".config/yarn/global/node_modules/a.js")

        let items = await Scanner(home: home.url).scan(RuleCatalog.all)

        #expect(!items.contains { $0.ruleID == "projects.node-modules" })
    }
}
