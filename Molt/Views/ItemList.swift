import AppKit
import SwiftUI

/// One category's items. Rows can be selected like in Finder (⇧ and ⌘ click) and checked together with
/// Space or the context menu; Size and Last Changed sort the list.
struct ItemList: View {
    let model: AppModel
    let category: Category
    @State private var selection: Set<CleanupItem.ID> = []
    @State private var sortOrder = [KeyPathComparator(\CleanupItem.size, order: .reverse)]

    var body: some View {
        let items = model.visibleItems(in: category).sorted(using: sortOrder)
        VStack(spacing: 0) {
            header(items)
            Divider()
            notice
            if items.isEmpty {
                emptyState
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                table(items)
            }
        }
        .motion(.smooth, value: items.map(\.id))
        .onChange(of: category) { selection.removeAll() }
    }

    private func header(_ items: [CleanupItem]) -> some View {
        @Bindable var model = model
        let allChecked = !items.isEmpty && items.allSatisfy(model.isChecked)
        return HStack(spacing: 12) {
            Picker("Trust", selection: $model.trustFilter) {
                Text("All").tag(Trust?.none)
                ForEach(Trust.allCases, id: \.self) { trust in
                    Text(trust.title).tag(Optional(trust))
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .fixedSize()
            Picker("Age", selection: $model.ageFilter) {
                ForEach(AgeFilter.allCases, id: \.self) { age in
                    Text(age.title).tag(age)
                }
            }
            .labelsHidden()
            .fixedSize()
            .help("Show only items not changed for a while")
            .accessibilityLabel("Age")
            Spacer()
            if !items.isEmpty {
                HStack(spacing: 4) {
                    Text("\(items.count) items")
                    Text(verbatim: "·").accessibilityHidden(true)
                    Text(items.totalSize.fileSize)
                }
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .lineLimit(1)
                .accessibilityElement(children: .combine)
            }
            Button(allChecked ? "Uncheck All" : "Check All") { model.setChecked(!allChecked, for: items) }
                .fixedSize()
                .disabled(items.isEmpty || model.isCleaning)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    /// What the user can change outside the list so Molt finds more.
    @ViewBuilder private var notice: some View {
        if category == .appleDevices, model.backupsNeedFullDiskAccess {
            NoticeBar(
                text: "macOS protects device backups. Give Molt Full Disk Access in Privacy & Security to list them.",
                systemImage: "lock"
            ) {
                Button("Open Privacy Settings") {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
                }
            }
            Divider()
        } else if category == .projects {
            NoticeBar(
                text: "Desktop, Documents and Downloads are not searched, so macOS does not ask for permission. Add project folders there in Settings.",
                systemImage: "folder.badge.questionmark"
            ) {
                SettingsLink { Text("Project Folders…") }
            }
            Divider()
        }
    }

    @ViewBuilder private var emptyState: some View {
        if model.scanningCategories.contains(category) {
            MascotMessage(mascot: .scanning, title: "Scanning…") {
                ProgressView().controlSize(.small)
            }
        } else if model.trustFilter != nil || model.ageFilter != .any {
            ContentUnavailableView {
                Label("No Matching Items", systemImage: "line.3.horizontal.decrease.circle")
            } actions: {
                Button("Show All Items") {
                    model.trustFilter = nil
                    model.ageFilter = .any
                }
            }
        } else {
            MascotMessage(mascot: .nothingToClean, title: "Nothing to Clean", message: "This category is already clean.")
        }
    }

    private func table(_ items: [CleanupItem]) -> some View {
        Table(items, selection: $selection, sortOrder: $sortOrder) {
            TableColumn(Text(Image(systemName: "checkmark"))) { item in
                Toggle(isOn: Binding(get: { model.isChecked(item) }, set: { model.setChecked($0, for: [item]) })) {
                    if let rule = model.rule(for: item) { Text(rule.name) }
                }
                .labelsHidden()
                .accessibilityHint(Text(item.url.displayPath))
            }
            .width(24)
            TableColumn("Name") { item in
                if let rule = model.rule(for: item) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(rule.name)
                        Text(item.url.displayPath)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .truncationMode(.middle)
                    }
                    .help(Text("\(Text(rule.summary)) \(Text(rule.recovery))"))
                    .accessibilityElement(children: .combine)
                    .accessibilityHint(Text("\(Text(rule.summary)) \(Text(rule.recovery))"))
                }
            }
            TableColumn("Trust") { item in
                if let rule = model.rule(for: item) { TrustBadge(trust: rule.trust) }
            }
            .width(80)
            TableColumn("Last Changed", value: \.sortDate) { item in
                if let date = item.lastModified {
                    Text(date, format: .relative(presentation: .named))
                        .foregroundStyle(.secondary)
                }
            }
            .width(120)
            TableColumn("Size", value: \.size) { item in
                Text(item.size.fileSize)
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .width(80)
        }
        .contextMenu(forSelectionType: CleanupItem.ID.self) { ids in
            let chosen = items.filter { ids.contains($0.id) }
            Button("Check") { model.setChecked(true, for: chosen) }
            Button("Uncheck") { model.setChecked(false, for: chosen) }
            Divider()
            Button("Show in Finder") { NSWorkspace.shared.activateFileViewerSelecting(chosen.map(\.url)) }
            Button("Never Suggest Again") { model.protect(chosen) }
        } primaryAction: { ids in
            toggle(items.filter { ids.contains($0.id) })
        }
        .onKeyPress(.space) {
            toggle(items.filter { selection.contains($0.id) })
            return .handled
        }
    }

    /// Checks the rows, or unchecks them when all of them are already checked.
    private func toggle(_ rows: [CleanupItem]) {
        guard !rows.isEmpty, !model.isCleaning else { return }
        model.setChecked(!rows.allSatisfy(model.isChecked), for: rows)
    }
}
