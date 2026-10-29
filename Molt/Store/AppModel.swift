import Foundation
import Observation
import os

/// What the sidebar shows: the disk overview or one category's items.
enum SidebarSelection: Hashable {
    case overview
    case category(Category)
}

/// The single source of truth for the window: what the last scan found and what the user checked.
@Observable final class AppModel {
    let rules = RuleCatalog.available
    /// Scan results per category, largest item first.
    private(set) var itemsByCategory: [Category: [CleanupItem]] = [:] {
        didSet { sizeByCategory = itemsByCategory.mapValues(\.totalSize) }
    }
    /// Kept with the items so the sidebar, overview and bar do not add them up on every redraw.
    private(set) var sizeByCategory: [Category: Int64] = [:]
    /// Categories whose scan is still running. They fill in one by one.
    private(set) var scanningCategories: Set<Category> = []
    private(set) var volume = VolumeUsage.of()
    /// Everything Molt has freed on this Mac, from the history.
    private(set) var freedTotal = CleanupHistory().totalFreed()
    /// While cleaning: how many of the checked items are done, and how many there are.
    private(set) var cleaningProgress: (done: Int, total: Int)?
    /// Items checked for removal. Nothing is checked until the user checks it.
    private(set) var checked: Set<CleanupItem.ID> = []
    /// Folders the user asked Molt never to suggest again.
    private(set) var protectedPaths = PathList.protected.load()
    /// Folders searched for projects on top of the home folder (Settings > Project Folders).
    private(set) var projectFolders = PathList.projectFolders.load()
    /// The device backup folder exists but Molt may not read it: the direct build needs Full Disk Access.
    private(set) var backupsNeedFullDiskAccess = false
    var selection: SidebarSelection = .overview
    /// Shows only items of this trust level; `nil` shows all.
    var trustFilter: Trust?
    var ageFilter = AgeFilter.any
    /// Shown after a cleanup in which some items could not be removed.
    var failureMessage: String?

    private let rulesByID: [String: Rule]
    private var home = MoltLocations.home
    /// The App Store build asks for the home folder once per launch, not on every scan.
    private var hasHomeAccess = false
    private let log = Logger(subsystem: "miedinger.Molt", category: "scan")

    init() {
        rulesByID = Dictionary(uniqueKeysWithValues: rules.map { ($0.id, $0) })
    }

    var isScanning: Bool { !scanningCategories.isEmpty }
    var isCleaning: Bool { cleaningProgress != nil }

    func rule(for item: CleanupItem) -> Rule? { rulesByID[item.ruleID] }

    func size(of category: Category) -> Int64 { sizeByCategory[category, default: 0] }

    var totalSize: Int64 { sizeByCategory.values.reduce(0, +) }

    /// The category's items that pass the trust and age filters.
    func visibleItems(in category: Category) -> [CleanupItem] {
        itemsByCategory[category, default: []].filter { item in
            (trustFilter == nil || rule(for: item)?.trust == trustFilter) && ageFilter.includes(item.lastModified)
        }
    }

    var checkedItems: [CleanupItem] { itemsByCategory.values.joined().filter { checked.contains($0.id) } }

    // MARK: Checking

    func isChecked(_ item: CleanupItem) -> Bool { checked.contains(item.id) }

    func setChecked(_ isChecked: Bool, for items: some Sequence<CleanupItem>) {
        let ids = items.map(\.id)
        if isChecked { checked.formUnion(ids) } else { checked.subtract(ids) }
    }

    /// Checks every safe item in every category, the one-click cleanup.
    func checkAllSafeItems() {
        setChecked(true, for: itemsByCategory.values.joined().filter { rule(for: $0)?.trust == .safe })
    }

    func uncheckAll() { checked.removeAll() }

    // MARK: Protecting

    /// Hides the items now and in every later scan.
    func protect(_ items: [CleanupItem]) {
        protectedPaths = Array(Set(protectedPaths + items.map(\.url.plainPath))).sorted()
        try? PathList.protected.save(protectedPaths)
        removeFromList(items)
    }

    /// Lets Molt suggest the folder again from the next scan on.
    func unprotect(_ path: String) {
        protectedPaths.removeAll { $0 == path }
        try? PathList.protected.save(protectedPaths)
    }

    // MARK: Project folders

    /// Adds a folder to search for projects and scans again. Only folders inside the home folder can be
    /// cleaned, so others are refused.
    func addProjectFolder(_ url: URL) {
        guard url.isInside(home), url.plainPath != home.plainPath else { return }
        projectFolders = Array(Set(projectFolders + [url.plainPath])).sorted()
        try? PathList.projectFolders.save(projectFolders)
        Task { await scan() }
    }

    func removeProjectFolder(_ path: String) {
        projectFolders.removeAll { $0 == path }
        try? PathList.projectFolders.save(projectFolders)
        Task { await scan() }
    }

    private func removeFromList(_ items: [CleanupItem]) {
        let ids = Set(items.map(\.id))
        for category in Category.allCases where itemsByCategory[category]?.contains(where: { ids.contains($0.id) }) == true {
            itemsByCategory[category]?.removeAll { ids.contains($0.id) }
        }
        checked.subtract(ids)
    }

    // MARK: Scanning and cleaning

    /// Scans every category at once and shows each as soon as it is done, so the window fills in while the
    /// slow ones (projects) are still running.
    func scan() async {
        guard !isScanning, !isCleaning else { return }
        #if APP_STORE
        // The sandbox reads only folders the user picked; Molt asks for the home folder once.
        if !hasHomeAccess {
            guard let granted = HomeFolderAccess.start() else { return }
            home = granted
            hasHomeAccess = true
        }
        #endif
        let scanner = Scanner(home: home, projectFolders: projectFolders.map { URL(filePath: $0, directoryHint: .isDirectory) })
        let rules = rules
        let protectedPaths = protectedPaths
        scanningCategories = Set(Category.allCases)
        let start = ContinuousClock.now

        await withTaskGroup(of: (Category, [CleanupItem], Duration).self) { group in
            for category in Category.allCases {
                let categoryRules = rules.filter { $0.category == category }
                group.addTask {
                    let begin = ContinuousClock.now
                    let items = await scanner.scan(categoryRules, among: rules)
                    return (category, items, begin.duration(to: .now))
                }
            }
            for await (category, items, duration) in group {
                itemsByCategory[category] = items
                    .filter { !PathList.contains($0.url, in: protectedPaths) }
                    .sorted { $0.size > $1.size }
                scanningCategories.remove(category)
                log.notice("\(category.rawValue, privacy: .public): \(items.count) items, \(self.size(of: category)) bytes in \(duration.formatted(.units(allowed: [.seconds], fractionalPart: .show(length: 2))), privacy: .public)")
            }
        }
        log.notice("Scan finished in \(start.duration(to: .now).formatted(.units(allowed: [.seconds], fractionalPart: .show(length: 2))), privacy: .public)")
        checked.formIntersection(itemsByCategory.values.joined().map(\.id))
        backupsNeedFullDiskAccess = MoltLocations.isUnreadable(MoltLocations.deviceBackups(in: home))
        volume = VolumeUsage.of(home)
    }

    /// Removes the checked items and takes them off the list one by one. No new scan is needed.
    func cleanChecked() async {
        guard !isCleaning, !isScanning else { return }
        let items = checkedItems
        cleaningProgress = (0, items.count)
        var removed: [CleanupHistory.Entry] = []
        var failed = 0

        for item in items {
            guard let rule = rule(for: item) else { continue }
            do {
                try await SafeRemover.remove(item, trust: rule.trust, home: home)
                removed.append(.init(date: .now, ruleID: rule.id, path: item.url.displayPath, bytes: item.size))
                removeFromList([item])
            } catch {
                failed += 1
            }
            cleaningProgress?.done += 1
        }

        let history = CleanupHistory()
        try? history.append(removed)
        freedTotal = history.totalFreed()
        if failed > 0 {
            failureMessage = String(localized: "\(failed) items could not be removed. They changed since the scan or are protected.")
        }
        cleaningProgress = nil
        volume = VolumeUsage.of(home)
    }
}
