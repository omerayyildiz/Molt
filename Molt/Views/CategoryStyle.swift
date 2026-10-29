import SwiftUI

extension Category {
    /// The category's color in the sidebar, the overview bar and its legend.
    var color: Color {
        switch self {
        case .xcode: .blue
        case .simulators: .cyan
        case .appleDevices: .indigo
        case .projects: .orange
        case .packageManagers: .brown
        case .ai: .purple
        case .apps: .pink
        case .system: .teal
        }
    }
}
