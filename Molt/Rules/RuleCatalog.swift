import Foundation

/// Every rule Molt knows. Each group lives in its own file in this folder; a new rule needs a test.
/// Paths are a first draft and are checked on a real Mac before a release.
nonisolated enum RuleCatalog {
    static let all: [Rule] = xcode + simulators + appleDevices + projects + packageManagers + ai + apps + system

    /// The rules this build can run. Rules that need a tool (`xcrun simctl`, `docker`) will be left out of
    /// the App Store build, whose sandbox cannot run them.
    static var available: [Rule] { all }
}
