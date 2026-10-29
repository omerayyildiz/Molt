// swift-tools-version: 6.2
// Builds Molt's UI-free code (models, rules and services) as a library so it can be tested with `swift test`
// without launching the app. The app itself is built from Molt.xcodeproj.
import PackageDescription

let package = Package(
    name: "MoltCore",
    platforms: [.macOS(.v15)],
    targets: [
        .target(
            name: "MoltCore",
            path: "Molt",
            // Everything that needs AppKit or SwiftUI stays in the app.
            exclude: [
                "Assets.xcassets", "Localizable.xcstrings", "MoltApp.swift", "ContentView.swift", "Store", "Views",
                "Services/HomeFolderAccess.swift",
            ],
            sources: ["Models", "Rules", "Services", "Support"],
            swiftSettings: appSettings
        ),
        .testTarget(
            name: "MoltCoreTests",
            dependencies: ["MoltCore"],
            path: "Tests/MoltCoreTests",
            swiftSettings: appSettings
        ),
    ]
)

/// Mirrors the app targets' build settings, so the tests compile the code the way Xcode does.
var appSettings: [SwiftSetting] {
    [
        .defaultIsolation(MainActor.self),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
