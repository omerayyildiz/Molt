import SwiftUI

/// A one-line note above a list, with an optional action, for things the user can fix outside Molt.
struct NoticeBar<Action: View>: View {
    let text: LocalizedStringKey
    let systemImage: String
    @ViewBuilder let action: Action

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(text)
                .font(.callout)
                .foregroundStyle(.secondary)
                // A size-fixing modifier here made the window grow to the text's ideal height.
                .lineLimit(2)
            Spacer(minLength: 8)
            action
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.quaternary.opacity(0.5))
        .accessibilityElement(children: .contain)
    }
}
