import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var cleanupViewModel = CleanupViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        Group {
            if #available(macOS 13.0, *) {
                NavigationSplitView {
                    SidebarView(viewModel: mainViewModel)
                } detail: {
                    mainContent
                }
                .navigationTitle("Package Cleaner")
            } else {
                HStack(spacing: 0) {
                    SidebarView(viewModel: mainViewModel)
                        .frame(width: 250)
                    Divider()
                    mainContent
                }
                .navigationTitle("Package Cleaner")
            }
        }
        .overlay {
            if mainViewModel.isScanning, let progress = mainViewModel.scanProgress {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressOverlay(
                    title: "Scanning...",
                    message: "\(progress.directoriesFound) directories found\n\(progress.formattedSize)",
                    progress: nil,
                    onCancel: mainViewModel.cancelScan
                )
            }
            
            if cleanupViewModel.isDeleting, let progress = cleanupViewModel.cleanupProgress {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressOverlay(
                    title: "Deleting...",
                    message: "\(progress.completed) of \(progress.total)\n\(progress.formattedFreedSpace) freed",
                    progress: progress.percentage,
                    onCancel: cleanupViewModel.cancelDeletion
                )
            }
        }
        .alert("Confirm Deletion", isPresented: $cleanupViewModel.showingConfirmation) {
            Button("Cancel", role: .cancel, action: cleanupViewModel.cancelDeletion)
            Button("Delete", role: .destructive) {
                cleanupViewModel.confirmDeletion(
                    directories: mainViewModel.selectedDirectoriesArray,
                    onComplete: mainViewModel.removeDeletedDirectories
                )
            }
        } message: {
            Text("Are you sure you want to delete \(mainViewModel.selectedDirectories.count) package directories?\n\nTotal size: \(mainViewModel.selectedSize.formattedByteCount)")
        }
        .alert("Cleanup Complete", isPresented: $cleanupViewModel.showingResult) {
            Button("OK", role: .cancel) {}
        } message: {
            if let result = cleanupViewModel.lastResult {
                Text(resultMessage(result))
            }
        }
        .alert("Error", isPresented: Binding(
            get: { mainViewModel.errorMessage != nil },
            set: { if !$0 { mainViewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = mainViewModel.errorMessage {
                Text(error)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: settingsViewModel)
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            ToolbarView(
                mainViewModel: mainViewModel,
                cleanupViewModel: cleanupViewModel,
                showingSettings: $showingSettings
            )
            
            Divider()
            
            DirectoryListView(viewModel: mainViewModel)
            
            Divider()
            
            statusBar
        }
    }
    
    private var statusBar: some View {
        HStack {
            Text("\(mainViewModel.filteredAndSortedResults.count) directories")
                .font(.caption)
            
            Spacer()
            
            if !mainViewModel.selectedDirectories.isEmpty {
                Text("\(mainViewModel.selectedDirectories.count) selected (\(mainViewModel.selectedSize.formattedByteCount))")
                    .font(.caption)
                
                Spacer()
            }
            
            Text("Total: \(mainViewModel.totalSize.formattedByteCount)")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    private func resultMessage(_ result: CleanupResult) -> String {
        var message = "Successfully deleted \(result.successCount) directories\n"
        message += "Freed space: \(result.formattedFreedSpace)"
        
        if result.failureCount > 0 {
            message += "\n\nFailed: \(result.failureCount) directories"
            if let firstError = result.errors.first {
                message += "\n\(firstError.localizedDescription)"
            }
        }
        
        return message
    }
}
