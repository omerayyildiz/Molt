import Foundation

nonisolated extension RuleCatalog {
    static let apps: [Rule] = [
        Rule(
            id: "apps.caches",
            category: .apps,
            name: "App Cache",
            summary: "Files an app keeps to load faster. Folders other rules know are listed under their own group.",
            recovery: "The app recreates it.",
            trust: .safe,
            // Apple's own caches are left alone: macOS protects several of them and recreates them anyway.
            locator: .contents(of: "Library/Caches", skipping: ["com.apple."])
        ),
    ]

    static let system: [Rule] = [
        Rule(
            id: "system.logs",
            category: .system,
            name: "Logs",
            summary: "Logs and crash reports written by apps.",
            recovery: "Apps write new ones. Old logs are not needed.",
            trust: .safe,
            locator: .contents(of: "Library/Logs")
        ),
    ]
}
