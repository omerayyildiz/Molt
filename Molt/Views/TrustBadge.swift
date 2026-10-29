import SwiftUI

struct TrustBadge: View {
    let trust: Trust

    var body: some View {
        Text(trust.title)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .foregroundStyle(color)
            .background(color.opacity(0.15), in: .capsule)
            .accessibilityLabel(Text("Trust: \(Text(trust.title))"))
    }

    private var color: Color {
        switch trust {
        case .safe: .green
        case .caution: .orange
        case .risky: .red
        }
    }
}
