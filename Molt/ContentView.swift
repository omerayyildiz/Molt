import SwiftUI

struct ContentView: View {
    let model: AppModel
    @State private var confirmsCleaning = false
    @State private var columns = ContentView.initialColumns

    var body: some View {
        NavigationSplitView(columnVisibility: $columns) {
            Sidebar(model: model)
                .navigationSplitViewColumnWidth(min: 210, ideal: 240)
                .hidingSidebarToggleForScreenshots()
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
                .overlay(alignment: .bottom) {
                    if let result = model.lastCleanup {
                        CleanupDoneCard(model: model, count: result.count, bytes: result.bytes)
                            .padding(16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .motion(.spring(duration: 0.45), value: model.lastCleanup?.bytes)
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
        .task {
            await model.scan()
            #if DEBUG
            await ScreenshotTour.runIfRequested(model: model)
            #endif
        }
    }
}

private extension View {
    /// The screenshot tour draws the window into a bitmap, which cannot draw the toolbar's glass: the sidebar
    /// button would show as an empty white circle, so the tour hides it.
    @ViewBuilder func hidingSidebarToggleForScreenshots() -> some View {
        #if DEBUG
        if UserDefaults.standard.string(forKey: "screenshotFolder") != nil {
            toolbar(removing: .sidebarToggle)
        } else {
            self
        }
        #else
        self
        #endif
    }
}

private extension ContentView {
    /// The screenshot tour hides the sidebar: its frosted glass does not draw into a bitmap.
    static var initialColumns: NavigationSplitViewVisibility {
        #if DEBUG
        if UserDefaults.standard.string(forKey: "screenshotFolder") != nil { return .detailOnly }
        #endif
        return .automatic
    }
}
