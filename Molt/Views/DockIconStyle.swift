import AppKit
import SwiftUI

/// The background behind the crab in the Dock while Molt runs. macOS has no alternate app icons, and changing
/// the icon inside the app would break its signature, so Finder and Launchpad keep the standard ocean icon.
enum DockIconStyle: String, CaseIterable, Identifiable {
    case ocean
    case cream
    case sand
    case charcoal

    static let storageKey = "dockIconStyle"

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .ocean: "Ocean"
        case .cream: "Cream"
        case .sand: "Sand"
        case .charcoal: "Charcoal"
        }
    }

    var imageName: String { "DockIcon\(rawValue.prefix(1).uppercased())\(rawValue.dropFirst())" }

    static var saved: DockIconStyle {
        DockIconStyle(rawValue: UserDefaults.standard.string(forKey: storageKey) ?? "") ?? .ocean
    }

    /// Shows the style in the Dock. Ocean is the bundle's own icon, so it clears the override.
    func apply() {
        NSApp.applicationIconImage = self == .ocean ? nil : NSImage(named: imageName)
    }
}
