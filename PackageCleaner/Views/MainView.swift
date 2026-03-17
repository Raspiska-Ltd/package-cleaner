import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var cleanupViewModel = CleanupViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        mainContent
            .navigationTitle("Package Cleaner")
        .overlay {
            if cleanupViewModel.isDeleting, let progress = cleanupViewModel.cleanupProgress {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ModernProgressView(
                    title: "Cleaning Up",
                    subtitle: "\(progress.completed) of \(progress.total) deleted • \(progress.formattedFreedSpace) freed",
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
            ScanToolbarView(
                mainViewModel: mainViewModel,
                showingSettings: $showingSettings
            )
            
            Divider()
            
            if !mainViewModel.scanResults.isEmpty {
                ResultsToolbarView(
                    mainViewModel: mainViewModel,
                    cleanupViewModel: cleanupViewModel
                )
                
                Divider()
            }
            
            DirectoryListView(viewModel: mainViewModel)
        }
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
