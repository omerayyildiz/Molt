import SwiftUI

/// The bar under the content: what is checked, the Clean button, and progress while cleaning.
struct CleanBar: View {
    let model: AppModel
    let clean: () -> Void

    var body: some View {
        let checkedItems = model.checkedItems
        let size = checkedItems.totalSize
        HStack(spacing: 12) {
            if let progress = model.cleaningProgress {
                ProgressView(value: Double(progress.done), total: Double(max(progress.total, 1)))
                    .frame(width: 140)
                    .accessibilityLabel("Cleaning")
                Text("Cleaning \(progress.done) of \(progress.total)…")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            } else {
                Text(checkedItems.isEmpty ? "Check items to clean them" : "\(checkedItems.count) items checked")
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            Spacer()
            Button(action: clean) {
                Text(checkedItems.isEmpty ? "Clean" : "Clean \(size.fileSize)")
                    .contentTransition(.numericText())
                    .frame(minWidth: 90)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .keyboardShortcut(.delete, modifiers: .command)
            .help("Clean the checked items (⌘⌫)")
            .disabled(checkedItems.isEmpty || model.isCleaning || model.isScanning)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.bar)
        .motion(.snappy, value: size)
    }
}
