import Foundation

/// The groups in the sidebar, in the order they are shown.
nonisolated enum Category: String, Sendable, CaseIterable, Identifiable {
    case xcode
    case simulators
    case appleDevices
    case projects
    case packageManagers
    case ai
    case apps
    case system

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .xcode: "Xcode"
        case .simulators: "Simulators"
        case .appleDevices: "iPhone and iPad"
        case .projects: "Projects"
        case .packageManagers: "Package Managers"
        case .ai: "AI Models"
        case .apps: "App Caches"
        case .system: "Logs"
        }
    }

    /// One line under the title in the overview, like the categories in System Settings > Storage.
    var summary: LocalizedStringResource {
        switch self {
        case .xcode: "Build files, previews, device support and archives"
        case .simulators: "Caches of the iOS Simulator"
        case .appleDevices: "Device backups and downloaded iOS installers"
        case .projects: "Dependencies and build output inside your projects"
        case .packageManagers: "Downloads kept by npm, Homebrew, pip and others"
        case .ai: "Models downloaded to run on this Mac"
        case .apps: "Files apps keep to load faster"
        case .system: "Logs and crash reports"
        }
    }

    var systemImage: String {
        switch self {
        case .xcode: "hammer"
        case .simulators: "iphone"
        case .appleDevices: "ipad.and.iphone"
        case .projects: "folder"
        case .packageManagers: "shippingbox"
        case .ai: "brain"
        case .apps: "app.dashed"
        case .system: "doc.text"
        }
    }
}
