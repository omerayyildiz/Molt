import AppKit
import SwiftUI

/// Molt > Settings: the Dock icon, extra folders to search for projects, and folders Molt never suggests.
struct SettingsView: View {
    let model: AppModel
    @AppStorage(DockIconStyle.storageKey) private var dockIconStyle = DockIconStyle.ocean

    var body: some View {
        Form {
            Section {
                HStack(spacing: 14) {
                    ForEach(DockIconStyle.allCases) { style in
                        dockIconChoice(style)
                    }
                }
                .frame(maxWidth: .infinity)
            } header: {
                Text("Dock Icon")
            } footer: {
                Text("Shown in the Dock while Molt is open. Finder and Launchpad keep the standard icon.")
                    .foregroundStyle(.secondary)
            }

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
        .frame(width: 540, height: 500)
        .onChange(of: dockIconStyle) { dockIconStyle.apply() }
    }

    private func dockIconChoice(_ style: DockIconStyle) -> some View {
        let isSelected = dockIconStyle == style
        return Button { dockIconStyle = style } label: {
            VStack(spacing: 6) {
                Image(style.imageName)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 3)
                    }
                Text(style.title)
                    .font(.callout)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(style.title))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
