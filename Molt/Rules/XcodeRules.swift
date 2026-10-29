import Foundation

nonisolated extension RuleCatalog {
    static let xcode: [Rule] = [
        Rule(
            id: "xcode.derived-data",
            category: .xcode,
            name: "Derived Data",
            summary: "Build products, indexes and logs Xcode keeps for each project.",
            recovery: "Xcode rebuilds it with the next build.",
            trust: .safe,
            locator: .contents(of: "Library/Developer/Xcode/DerivedData")
        ),
        Rule(
            id: "xcode.previews",
            category: .xcode,
            name: "SwiftUI Previews",
            summary: "Builds and simulators Xcode uses for SwiftUI previews.",
            recovery: "Xcode recreates it the next time a preview runs.",
            trust: .safe,
            locator: .folders(["Library/Developer/Xcode/UserData/Previews"])
        ),
        Rule(
            id: "xcode.device-support",
            category: .xcode,
            name: "Device Support",
            summary: "Debug symbols copied from each iOS and watchOS version you connected.",
            recovery: "Xcode copies them again when a device with that version is connected.",
            trust: .caution,
            locator: .contents(of: "Library/Developer/Xcode/iOS DeviceSupport")
        ),
        Rule(
            id: "xcode.watchos-device-support",
            category: .xcode,
            name: "Device Support",
            summary: "Debug symbols copied from each iOS and watchOS version you connected.",
            recovery: "Xcode copies them again when a device with that version is connected.",
            trust: .caution,
            locator: .contents(of: "Library/Developer/Xcode/watchOS DeviceSupport")
        ),
        Rule(
            id: "xcode.archives",
            category: .xcode,
            name: "Archives",
            summary: "App builds you archived for release, with the symbols needed to read their crash reports.",
            recovery: "They do not come back. They go to the Trash.",
            trust: .risky,
            locator: .contents(of: "Library/Developer/Xcode/Archives")
        ),
    ]

    static let simulators: [Rule] = [
        Rule(
            id: "simulators.caches",
            category: .simulators,
            name: "Simulator Caches",
            summary: "Caches the iOS Simulator keeps, including leftovers of deleted simulators.",
            recovery: "The Simulator recreates what it needs.",
            trust: .safe,
            locator: .folders(["Library/Developer/CoreSimulator/Caches"])
        ),
    ]
}
