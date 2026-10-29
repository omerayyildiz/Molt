import Foundation

/// Download caches of package managers. Each one fills again with the next install.
nonisolated extension RuleCatalog {
    static let packageManagers: [Rule] = [
        cache("npm", "npm", ".npm/_cacache"),
        cache("npx", "npx", ".npm/_npx"),
        cache("yarn", "Yarn", "Library/Caches/Yarn"),
        cache("pnpm", "pnpm", "Library/pnpm/store"),
        cache("bun", "Bun", ".bun/install/cache"),
        cache("homebrew", "Homebrew", "Library/Caches/Homebrew"),
        cache("pip", "pip", "Library/Caches/pip"),
        cache("uv", "uv", ".cache/uv"),
        cache("cargo", "Cargo", ".cargo/registry/cache"),
        cache("gradle", "Gradle", ".gradle/caches"),
        cache("cocoapods", "CocoaPods", "Library/Caches/CocoaPods"),
    ]

    private static func cache(_ id: String, _ name: LocalizedStringResource, _ path: String) -> Rule {
        Rule(
            id: "packages.\(id)",
            category: .packageManagers,
            name: name,
            summary: "Packages this package manager downloaded, kept to install them faster next time.",
            recovery: "It downloads them again with the next install.",
            trust: .safe,
            locator: .folders([path])
        )
    }
}
