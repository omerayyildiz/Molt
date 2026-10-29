import AppKit
import SwiftUI

/// Molt > Settings: extra folders to search for projects, and folders Molt never suggests.
struct SettingsView: View {
    let model: AppModel

    var body: some View {
        Form {
            Section {
                ForEach(model.projectFolders, id: \.self) { path in
                    folderRow(path, remove: model.removeProjectFolder)
                }
                Button("Add Folder…", action: chooseProjectFolder)
            } header: {
                Text("Project Folders")
            } footer: {
                Text("Your home folder is always searched, except Desktop, Documents and Downloads, where macOS asks for permission first. Add a folder there to search it too.")
                    .foregroundStyle(.secondary)
            }

            Section {
                if model.protectedPaths.isEmpty {
                    Text("Nothing is protected. Right-click an item and choose Never Suggest Again to keep Molt from listing it.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(model.protectedPaths, id: \.self) { path in
                        folderRow(path, remove: model.unprotect)
                    }
                }
            } header: {
                Text("Never Suggested")
            } footer: {
                Text("Removed folders are suggested again from the next scan on.")
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 540, height: 460)
    }

    private func folderRow(_ path: String, remove: @escaping (String) -> Void) -> some View {
        let displayPath = URL(filePath: path).displayPath
        return HStack {
            Text(displayPath)
                .truncationMode(.middle)
            Spacer()
            Button("Remove") { remove(path) }
                .accessibilityLabel(Text("Remove \(displayPath)"))
        }
    }

    private func chooseProjectFolder() {
        let panel = NSOpenPanel()
        panel.message = String(localized: "Choose a folder with projects. It must be inside your home folder.")
        panel.prompt = String(localized: "Add")
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.directoryURL = MoltLocations.home.appending(path: "Documents")
        guard panel.runModal() == .OK, let url = panel.url else { return }
        model.addProjectFolder(url)
    }
}
