import Foundation

/// Finds what the rules describe and measures it. Reads only; never changes anything.
nonisolated struct Scanner: Sendable {
    let home: URL
    /// Where projects are searched for dependencies and build output: the home folder, then the folders the
    /// user added, which may sit inside folders the home search skips (`~/Documents/Code`).
    let projectRoots: [URL]
    /// How many folders deep projects are searched, counted from each root.
    var projectDepth = 6

    init(home: URL = MoltLocations.home, projectFolders: [URL] = []) {
        self.home = home
        self.projectRoots = [home] + projectFolders
    }

    /// Scans `rules`. Pass the whole `catalog` when scanning part of it, so a `contents(of:)` rule still skips
    /// folders that rules outside `rules` claim.
    @concurrent func scan(_ rules: [Rule], among catalog: [Rule]? = nil) async -> [CleanupItem] {
        let claimed = Set((catalog ?? rules).flatMap(\.locator.claimedPaths))
        var items: [CleanupItem] = []
        var projectRules: [Rule] = []

        for rule in rules {
            switch rule.locator {
            case .folders(let paths):
                items += paths.compactMap { item(at: home.appending(path: $0), rule: rule) }
            case .contents(let path, let skipping):
                let folder = home.appending(path: path, directoryHint: .isDirectory)
                let entries = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []
                for entry in entries {
                    let name = entry.lastPathComponent
                    guard name != ".DS_Store", !claimed.contains("\(path)/\(name)"), !skipping.contains(where: name.hasPrefix)
                    else { continue }
                    if let item = item(at: entry, rule: rule) { items.append(item) }
                }
            case .projectArtifact:
                projectRules.append(rule)
            }
        }
        return items + (await projectArtifacts(for: projectRules))
    }

    /// Finds the project folders, then measures them in parallel: measuring is the slow part (one
    /// node_modules folder can hold tens of thousands of files).
    private func projectArtifacts(for rules: [Rule]) async -> [CleanupItem] {
        let found = findProjectArtifacts(for: rules)
        return await withTaskGroup(of: CleanupItem?.self) { group in
            for candidate in found {
                group.addTask { item(at: candidate.url, rule: candidate.rule, lastModified: candidate.projectChanged) }
            }
            return await group.reduce(into: []) { items, item in
                if let item { items.append(item) }
            }
        }
    }

    /// Walks the project roots once for all project rules. Artifact folders are never entered, and neither are
    /// hidden folders, `~/Library`, the Trash and the folders macOS asks permission for
    /// (`MoltLocations.privacyProtectedFolders`).
    private func findProjectArtifacts(for rules: [Rule]) -> [(url: URL, rule: Rule, projectChanged: Date?)] {
        var rulesByFolder: [String: [(rule: Rule, markers: [String])]] = [:]
        for rule in rules {
            if case .projectArtifact(let folder, let markers) = rule.locator {
                rulesByFolder[folder, default: []].append((rule, markers))
            }
        }
        guard !rulesByFolder.isEmpty else { return [] }

        let excluded = Set((["Library", ".Trash"] + MoltLocations.privacyProtectedFolders).map { home.appending(path: $0).plainPath })
        let keys: [URLResourceKey] = [.isDirectoryKey, .isSymbolicLinkKey]
        // Keyed by path: a project folder inside the home folder is reached twice.
        var found: [String: (url: URL, rule: Rule, projectChanged: Date?)] = [:]

        for root in projectRoots {
            guard let walker = FileManager.default.enumerator(
                at: root,
                includingPropertiesForKeys: keys,
                options: [.skipsPackageDescendants],
                errorHandler: { _, _ in true }
            ) else { continue }

            for case let url as URL in walker {
                guard let values = try? url.resourceValues(forKeys: Set(keys)),
                      values.isDirectory == true, values.isSymbolicLink != true
                else { continue }
                let name = url.lastPathComponent

                if let candidates = rulesByFolder[name] {
                    walker.skipDescendants()
                    let project = url.deletingLastPathComponent()
                    for candidate in candidates {
                        guard let marker = candidate.markers.lazy
                            .map({ project.appending(path: $0) })
                            .first(where: { FileManager.default.fileExists(atPath: $0.plainPath) })
                        else { continue }
                        let projectChanged = marker.resourceValue(\.contentModificationDate, for: .contentModificationDateKey)
                        found[url.plainPath] = (url, candidate.rule, projectChanged)
                        break
                    }
                } else if name.hasPrefix(".") || walker.level >= projectDepth || excluded.contains(url.plainPath) {
                    walker.skipDescendants()
                }
            }
        }
        return Array(found.values)
    }

    private func item(at url: URL, rule: Rule, lastModified: Date? = nil) -> CleanupItem? {
        guard let values = try? url.resourceValues(forKeys: [.isSymbolicLinkKey, .contentModificationDateKey]),
              values.isSymbolicLink != true
        else { return nil }
        let size = DiskUsage.allocatedSize(of: url)
        guard size > 0 else { return nil }
        return CleanupItem(
            ruleID: rule.id,
            url: url,
            size: size,
            lastModified: lastModified ?? values.contentModificationDate,
            fileNumber: FileIdentity.number(of: url)
        )
    }
}
