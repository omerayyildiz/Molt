import AppKit
import SwiftUI

@main
struct MoltApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var model = AppModel()

    var body: some Scene {
        Window("Molt", id: "main") {
            // Passed explicitly rather than through the environment, as in ClaudeDeck: rows that AppKit hosts
            // and reuses (Table, List) can lose an environment object.
            ContentView(model: model)
        }
        .defaultSize(width: 1000, height: 640)

        Settings {
            SettingsView(model: model)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DockIconStyle.saved.apply()
    }
}
