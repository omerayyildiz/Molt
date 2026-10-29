import Foundation

/// How safe it is to remove an item. It decides how the item is removed.
nonisolated enum Trust: Int, Sendable, Comparable, CaseIterable {
    /// Comes back by itself or with the next build.
    case safe
    /// Comes back only by downloading or installing it again.
    case caution
    /// Does not come back. Goes to the Trash, never deleted outright.
    case risky

    static func < (lhs: Trust, rhs: Trust) -> Bool { lhs.rawValue < rhs.rawValue }

    /// Moving rebuildable files to the Trash would free no space, so only risky items go there.
    var removal: Removal { self == .risky ? .moveToTrash : .delete }

    var title: LocalizedStringResource {
        switch self {
        case .safe: "Safe"
        case .caution: "Caution"
        case .risky: "Risky"
        }
    }
}

nonisolated enum Removal: Sendable {
    case delete
    case moveToTrash
}
