import SwiftUI

struct ToolbarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var cleanupViewModel: CleanupViewModel
    @Binding var showingSettings: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: mainViewModel.startScan) {
                Label("Scan", systemImage: "magnifyingglass")
            }
            .disabled(mainViewModel.isScanning)
            .keyboardShortcut("r", modifiers: .command)
            
            Divider()
            
            Menu {
                ForEach(MainViewModel.SortOption.allCases, id: \.self) { option in
                    Button(action: { mainViewModel.sortOption = option }) {
                        HStack {
                            Text(option.rawValue)
                            if mainViewModel.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Label("Sort", systemImage: mainViewModel.sortOption.systemImage)
            }
            
            Divider()
            
            Button(action: {
                cleanupViewModel.requestDeletion(
                    directories: mainViewModel.selectedDirectoriesArray,
                    onComplete: mainViewModel.removeDeletedDirectories
                )
            }) {
                Label("Delete Selected", systemImage: "trash")
            }
            .disabled(mainViewModel.selectedDirectories.isEmpty || cleanupViewModel.isDeleting)
            .keyboardShortcut(.delete, modifiers: .command)
            
            Button(action: {
                mainViewModel.selectAutoCleanupCandidates()
                cleanupViewModel.requestDeletion(
                    directories: mainViewModel.autoCleanupCandidates,
                    onComplete: mainViewModel.removeDeletedDirectories
                )
            }) {
                Label("Auto-Cleanup", systemImage: "sparkles")
            }
            .disabled(mainViewModel.autoCleanupCandidates.isEmpty || cleanupViewModel.isDeleting)
            
            Spacer()
            
            TextField("Search", text: $mainViewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
            
            Button(action: { showingSettings = true }) {
                Label("Settings", systemImage: "gear")
            }
            .keyboardShortcut(",", modifiers: .command)
        }
        .padding(12)
    }
}
