import SwiftUI

/// Shown after a cleanup: Molt celebrates and says how much space came back. Closes itself after a while.
struct CleanupDoneCard: View {
    let model: AppModel
    let count: Int
    let bytes: Int64

    var body: some View {
        HStack(spacing: 16) {
            Mascot.done.image(height: 72)
            VStack(alignment: .leading, spacing: 3) {
                Text("All Clean!")
                    .font(.headline)
                Text("Freed \(bytes.fileSize)")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.tint)
                Text("\(count) items")
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 12)
            Button("OK") { model.dismissLastCleanup() }
                .keyboardShortcut(.defaultAction)
        }
        .padding(16)
        .frame(maxWidth: 420)
        // Solid rather than a material: it stays readable over a busy list and draws in screenshots.
        .background(Color(nsColor: .windowBackgroundColor), in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.separator))
        .shadow(color: .black.opacity(0.15), radius: 16, y: 6)
        .accessibilityElement(children: .contain)
        // Keyed by the result, so a second cleanup gets its own full time on screen.
        .task(id: "\(count)-\(bytes)") {
            try? await Task.sleep(for: .seconds(8))
            guard !Task.isCancelled else { return }
            model.dismissLastCleanup()
        }
    }
}
