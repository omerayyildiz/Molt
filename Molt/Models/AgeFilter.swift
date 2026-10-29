import Foundation

/// Shows only items not changed for a while, to find projects you no longer work on.
nonisolated enum AgeFilter: Int, Sendable, CaseIterable {
    case any
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear

    private var months: Int? {
        switch self {
        case .any: nil
        case .oneMonth: 1
        case .threeMonths: 3
        case .sixMonths: 6
        case .oneYear: 12
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .any: "Any Age"
        case .oneMonth: "Older Than 1 Month"
        case .threeMonths: "Older Than 3 Months"
        case .sixMonths: "Older Than 6 Months"
        case .oneYear: "Older Than 1 Year"
        }
    }

    /// Items without a date are left out once an age is chosen: their age is unknown.
    func includes(_ date: Date?, now: Date = .now, calendar: Calendar = .current) -> Bool {
        guard let months else { return true }
        guard let date, let cutoff = calendar.date(byAdding: .month, value: -months, to: now) else { return false }
        return date <= cutoff
    }
}
