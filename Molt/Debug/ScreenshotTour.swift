#if DEBUG
import AppKit

/// Saves the screens used in the README, on the website and in the App Store, then quits. Debug builds only.
/// The app draws its own windows into PNGs, so no screen recording permission is needed and it works with
/// the screen locked. `scripts/screenshots.sh` runs it in both appearances and languages.
///
///     Molt.app/Contents/MacOS/Molt -screenshotFolder <folder> -demoHome <folder> [-AppleLanguages "(tr)"]
enum ScreenshotTour {
    static func runIfRequested(model: AppModel) async {
        guard let path = UserDefaults.standard.string(forKey: "screenshotFolder") else { return }
        let folder = URL(filePath: path, directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        guard let window = NSApp.windows.first(where: { $0.isVisible && $0.canBecomeMain }) else { return }
        window.setFrame(NSRect(origin: window.frame.origin, size: NSSize(width: 1000, height: 640)), display: true)

        await show("1-overview", in: window, folder: folder) { model.selection = .overview }
        await show("2-projects", in: window, folder: folder) { model.selection = .category(.projects) }
        await show("3-xcode", in: window, folder: folder) {
            model.selection = .category(.xcode)
            model.setChecked(true, for: model.visibleItems(in: .xcode).prefix(3))
        }
        await show("4-done", in: window, folder: folder) {
            model.uncheckAll()
            model.selection = .overview
            model.showCleanupResult(count: 12, bytes: 3_400_000_000)
        }
        model.dismissLastCleanup()
        NSApp.terminate(nil)
    }

    private static func show(_ name: String, in window: NSWindow, folder: URL, setUp: () -> Void) async {
        setUp()
        // Long enough for the page to appear and its animations to finish.
        try? await Task.sleep(for: .seconds(1.5))
        capture(window, as: name, in: folder)
    }

    /// Draws the whole window, title bar included, at the screen's backing scale.
    private static func capture(_ window: NSWindow, as name: String, in folder: URL) {
        guard let view = window.contentView?.superview,
              let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds)
        else { return }
        view.cacheDisplay(in: view.bounds, to: bitmap)
        try? bitmap.representation(using: .png, properties: [:])?.write(to: folder.appending(path: "\(name).png"))
    }
}
#endif
