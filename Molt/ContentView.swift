import SwiftUI

struct ContentView: View {
    let model: AppModel
    @State private var confirmsCleaning = false

    var body: some View {
        NavigationSplitView {
            Sidebar(model: model)
                .navigationSplitViewColumnWidth(min: 210, ideal: 240)
        } detail: {
            // The bar sits below the content, not over it, so the last rows stay reachable. The content fills
            // the height even when it is empty, so the bar stays at the bottom.
            VStack(spacing: 0) {
                Group {
                    switch model.selection {
                    case .overview: DiskOverview(model: model)
                    case .category(let category): ItemList(model: model, category: category)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                CleanBar(model: model) { confirmsCleaning = true }
            }
            // Room for the filters, the count and Check All side by side.
            .frame(minWidth: 680, minHeight: 420)
        }
        .toolbar {
            ToolbarItemGroup {
                Menu("Check", systemImage: "checklist") {
                    Button("Check All Safe Items") { model.checkAllSafeItems() }
                        .keyboardShortcut("a", modifiers: [.command, .shift])
                    Button("Uncheck All") { model.uncheckAll() }
                }
                .help("Check or uncheck items in every category")
                .disabled(model.isScanning || model.isCleaning)
                Button("Scan Again", systemImage: "arrow.clockwise") {
                    Task { await model.scan() }
                }
                .help("Scan Again")
                .keyboardShortcut("r")
                .disabled(model.isScanning || model.isCleaning)
            }
        }
        // Lives here, not on a view that can disappear while the dialog is shown.
        .confirmationDialog("Clean \(model.checkedItems.count) items?", isPresented: $confirmsCleaning) {
            Button("Clean \(model.checkedItems.totalSize.fileSize)", role: .destructive) {
                Task { await model.cleanChecked() }
            }
        } message: {
            Text("Safe and caution items are deleted. Risky items go to the Trash.")
        }
        .alert(
            "Some Items Were Not Removed",
            isPresented: Binding(get: { model.failureMessage != nil }, set: { if !$0 { model.failureMessage = nil } })
        ) {
            Button("OK") {}
        } message: {
            Text(model.failureMessage ?? "")
        }
        .task { await model.scan() }
    }
}
