import SwiftUI

/// The startup disk the way System Settings > Storage shows it: one bar split by category, a legend, and a
/// list of categories that open their items.
struct DiskOverview: View {
    let model: AppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let volume = model.volume {
                    diskPanel(volume)
                }
                categoryList
            }
            .padding(24)
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity)
        }
        .motion(.smooth, value: model.totalSize)
    }

    private func diskPanel(_ volume: VolumeUsage) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(volume.name).font(.title2.bold())
                    Text("\(volume.used.fileSize) of \(volume.total.fileSize) used")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(model.totalSize.fileSize)
                        .font(.title2.bold())
                        .contentTransition(.numericText())
                    Text(model.isScanning ? "found so far" : "can be freed")
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
            UsageBar(segments: segments(volume), total: volume.total)
                .frame(height: 22)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Disk usage")
                .accessibilityValue(Text("\(volume.used.fileSize) of \(volume.total.fileSize) used"))
            legend(volume)
            if model.freedTotal > 0 {
                Label("Molt has freed \(model.freedTotal.fileSize) on this Mac so far.", systemImage: "sparkles")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .background(.background.secondary, in: .rect(cornerRadius: 12))
    }

    private func segments(_ volume: VolumeUsage) -> [UsageBar.Segment] {
        let found = Category.allCases.map { UsageBar.Segment(id: $0.rawValue, size: model.size(of: $0), color: $0.color) }
        let other = UsageBar.Segment(id: "other", size: max(volume.used - model.totalSize, 0), color: .gray.opacity(0.55))
        return found + [other]
    }

    private func legend(_ volume: VolumeUsage) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), alignment: .leading)], alignment: .leading, spacing: 6) {
            ForEach(Category.allCases.filter { model.size(of: $0) > 0 }) { category in
                legendEntry(Text(category.title), size: model.size(of: category), color: category.color)
            }
            legendEntry(Text("Other Data"), size: max(volume.used - model.totalSize, 0), color: .gray.opacity(0.55))
            legendEntry(Text("Available"), size: volume.available, color: .primary.opacity(0.1))
        }
        .font(.callout)
    }

    private func legendEntry(_ title: Text, size: Int64, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 9, height: 9).accessibilityHidden(true)
            title
            Text(size.fileSize)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }

    private var categoryList: some View {
        VStack(spacing: 0) {
            ForEach(Category.allCases) { category in
                Button { model.selection = .category(category) } label: {
                    HStack(spacing: 12) {
                        Image(systemName: category.systemImage)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .background(category.color.gradient, in: .rect(cornerRadius: 7))
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.title).font(.headline)
                            Text(category.summary).font(.callout).foregroundStyle(.secondary)
                        }
                        Spacer()
                        CategorySize(model: model, category: category)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityHint("Shows the items in this category")
                if category != Category.allCases.last {
                    Divider().padding(.leading, 56)
                }
            }
        }
        .background(.background.secondary, in: .rect(cornerRadius: 12))
    }
}

/// A horizontal bar split into colored parts; the rest of `total` shows as free space.
struct UsageBar: View {
    struct Segment: Identifiable {
        let id: String
        let size: Int64
        let color: Color
    }

    let segments: [Segment]
    let total: Int64

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 1) {
                ForEach(segments.filter { $0.size > 0 }) { segment in
                    // Small categories keep a sliver so they stay visible next to the large ones.
                    segment.color
                        .frame(width: max(geometry.size.width * Double(segment.size) / Double(max(total, 1)), 3))
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.primary.opacity(0.1))
            .clipShape(.rect(cornerRadius: 6))
        }
    }
}
