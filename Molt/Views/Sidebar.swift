import SwiftUI

struct Sidebar: View {
    let model: AppModel

    var body: some View {
        // Non-optional in the model: clicking empty space keeps the current page.
        let selection = Binding<SidebarSelection?>(get: { model.selection }, set: { if let new = $0 { model.selection = new } })
        List(selection: selection) {
            Label("Overview", systemImage: "internaldrive")
                .tag(SidebarSelection.overview)
            Section("Categories") {
                ForEach(Category.allCases) { category in
                    Label {
                        HStack {
                            Text(category.title)
                            Spacer()
                            CategorySize(model: model, category: category)
                        }
                    } icon: {
                        Image(systemName: category.systemImage)
                            .foregroundStyle(category.color)
                    }
                    .accessibilityElement(children: .combine)
                    .tag(SidebarSelection.category(category))
                }
            }
        }
    }
}

/// A category's size, or a spinner while it is still being scanned.
struct CategorySize: View {
    let model: AppModel
    let category: Category

    var body: some View {
        if model.scanningCategories.contains(category) {
            ProgressView()
                .controlSize(.mini)
                .accessibilityLabel("Scanning")
        } else {
            let size = model.size(of: category)
            Text(size.fileSize)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .contentTransition(.numericText())
                .motion(.snappy, value: size)
        }
    }
}
