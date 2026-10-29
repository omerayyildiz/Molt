import Foundation

nonisolated extension RuleCatalog {
    static let appleDevices: [Rule] = [
        Rule(
            id: "devices.backups",
            category: .appleDevices,
            name: "Device Backup",
            summary: "A backup of an iPhone or iPad made by Finder.",
            recovery: "It does not come back. It goes to the Trash.",
            trust: .risky,
            locator: .contents(of: "Library/Application Support/MobileSync/Backup")
        ),
        Rule(
            id: "devices.software-updates",
            category: .appleDevices,
            name: "Software Updates",
            summary: "iOS and iPadOS installers Finder downloaded to update or restore a device.",
            recovery: "Finder downloads them again when needed.",
            trust: .safe,
            locator: .folders(["Library/iTunes/iPhone Software Updates", "Library/iTunes/iPad Software Updates"])
        ),
    ]
}
