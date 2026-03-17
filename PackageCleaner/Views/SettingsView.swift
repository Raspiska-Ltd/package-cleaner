import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            generalSettings
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            
            scanSettings
                .tabItem {
                    Label("Scan", systemImage: "magnifyingglass")
                }
            
            packageTypesSettings
                .tabItem {
                    Label("Package Types", systemImage: "shippingbox")
                }
        }
        .frame(width: 600, height: 400)
    }
    
    private var generalSettings: some View {
        Form {
            Section("Cleanup Behavior") {
                Toggle("Move to Trash (instead of permanent delete)", isOn: $viewModel.settingsStore.moveToTrash)
                
                Stepper(
                    "Auto-cleanup threshold: \(viewModel.settingsStore.autoCleanupThresholdDays) days",
                    value: $viewModel.settingsStore.autoCleanupThresholdDays,
                    in: 30...365,
                    step: 30
                )
            }
        }
        .padding()
        .onChange(of: viewModel.settingsStore.moveToTrash) { _ in
            viewModel.saveSettings()
        }
        .onChange(of: viewModel.settingsStore.autoCleanupThresholdDays) { _ in
            viewModel.saveSettings()
        }
    }
    
    private var scanSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scan Directories")
                .font(.headline)
            
            List {
                ForEach(viewModel.settingsStore.scanDirectories, id: \.self) { directory in
                    HStack {
                        Image(systemName: "folder")
                        Text(directory.path)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                .onDelete(perform: viewModel.removeScanDirectory)
            }
            
            Button("Add Directory...") {
                viewModel.showingDirectoryPicker = true
            }
        }
        .padding()
        .fileImporter(
            isPresented: $viewModel.showingDirectoryPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                viewModel.addScanDirectory(url)
            }
        }
    }
    
    private var packageTypesSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enabled Package Types")
                .font(.headline)
            
            Text("Select which package directory types to scan for:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            List {
                ForEach(PackageType.allCases) { type in
                    Toggle(isOn: Binding(
                        get: { viewModel.settingsStore.enabledPackageTypes.contains(type) },
                        set: { _ in viewModel.togglePackageType(type) }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(type.displayName)
                                .font(.body)
                            Text(type.associatedLanguages.map { $0.displayName }.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
