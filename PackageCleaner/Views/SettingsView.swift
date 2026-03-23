import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingResetConfirmation = false
    @State private var showingResetSuccess = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(Color(nsColor: .windowBackgroundColor))
            
            Divider()
            
            TabView(selection: $viewModel.selectedTab) {
                generalSettings
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                    .tag(0)
                
                scanSettings
                    .tabItem {
                        Label("Scan", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                packageTypesSettings
                    .tabItem {
                        Label("Package Types", systemImage: "shippingbox")
                    }
                    .tag(2)
                
                aboutSettings
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
                    .tag(3)
            }
        }
        .frame(width: 650, height: 500)
        .alert("Reset to Defaults", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                viewModel.resetToDefaults()
                showingResetSuccess = true
            }
        } message: {
            Text("This will reset all settings to their default values. This action cannot be undone.")
        }
        .alert("Settings Reset", isPresented: $showingResetSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("All settings have been reset to their default values.")
        }
    }
    
    private var generalSettings: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset to Defaults")
                        }
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Reset all settings to default values")
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                ModernCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cleanup Behavior")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Configure how package directories are deleted")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        Toggle(isOn: $viewModel.settingsStore.moveToTrash) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Move to Trash")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Files can be recovered from Trash (recommended)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                    }
                }
                
                ModernCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Auto-Cleanup Threshold")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Projects older than this will be marked for cleanup")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(viewModel.settingsStore.autoCleanupThresholdDays) days")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.accentColor)
                                Spacer()
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(viewModel.settingsStore.autoCleanupThresholdDays) },
                                    set: { viewModel.settingsStore.autoCleanupThresholdDays = Int($0) }
                                ),
                                in: 30...365,
                                step: 30
                            )
                            
                            HStack {
                                Text("30 days")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("365 days")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .onChange(of: viewModel.settingsStore.moveToTrash) { _ in
            viewModel.saveSettings()
        }
        .onChange(of: viewModel.settingsStore.autoCleanupThresholdDays) { _ in
            viewModel.saveSettings()
        }
    }
    
    private var scanSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            ModernCard {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "folder.badge.magnifyingglass")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Scan Directories")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Choose which directories to scan for package folders")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        ModernButton("Add", icon: "plus.circle.fill", style: .primary) {
                            viewModel.showingDirectoryPicker = true
                        }
                    }
                    
                    Divider()
                    
                    if viewModel.settingsStore.scanDirectories.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "folder.badge.questionmark")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No directories added")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(viewModel.settingsStore.scanDirectories.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Image(systemName: "folder.fill")
                                        .foregroundColor(.accentColor)
                                    
                                    Text(viewModel.settingsStore.scanDirectories[index].path)
                                        .font(.system(size: 13))
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.removeScanDirectory(at: IndexSet(integer: index))
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(nsColor: .controlBackgroundColor))
                                )
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .fileImporter(
            isPresented: $viewModel.showingDirectoryPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                // Start accessing security-scoped resource
                _ = url.startAccessingSecurityScopedResource()
                viewModel.addScanDirectory(url)
            }
        }
    }
    
    private var packageTypesSettings: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ModernCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Package Types")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Select which package directory types to scan for")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(spacing: 12) {
                            ForEach(PackageType.allCases) { type in
                                HStack(spacing: 12) {
                                    Toggle(isOn: Binding(
                                        get: { viewModel.settingsStore.enabledPackageTypes.contains(type) },
                                        set: { _ in viewModel.togglePackageType(type) }
                                    )) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "folder.fill")
                                                .foregroundColor(viewModel.settingsStore.enabledPackageTypes.contains(type) ? .accentColor : .secondary)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(type.displayName)
                                                    .font(.system(size: 14, weight: .medium))
                                                Text(type.associatedLanguages.map { $0.displayName }.joined(separator: ", "))
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    .toggleStyle(.switch)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(nsColor: .controlBackgroundColor))
                                )
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
    }
    
    private var aboutSettings: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "app.gift.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    
                    Text("Package Cleaner")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Version 1.0.0")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                ModernCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Raspiska Ltd")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Software Development Company")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Package Cleaner is a native macOS application designed to help developers reclaim disk space by finding and removing package dependency directories from development projects.")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                if let url = URL(string: "https://raspiska.co?utm_source=package-cleaner&utm_medium=app&utm_campaign=about") {
                                    NSWorkspace.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "globe")
                                    Text("Visit raspiska.co")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.blue.opacity(0.1))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                ModernCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Open Source")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Free and open source software")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.accentColor)
                                Text("MIT License")
                                    .font(.system(size: 13))
                            }
                            
                            Button(action: {
                                if let url = URL(string: "https://github.com/Raspiska-Ltd/package-cleaner") {
                                    NSWorkspace.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "link.circle.fill")
                                    Text("View on GitHub")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.accentColor.opacity(0.1))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                if let url = URL(string: "https://github.com/Raspiska-Ltd/package-cleaner/issues") {
                                    NSWorkspace.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "exclamationmark.bubble.fill")
                                    Text("Report an Issue")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(nsColor: .controlBackgroundColor))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Text("© 2026 Raspiska Ltd. All rights reserved.")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}
