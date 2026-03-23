import SwiftUI

struct DirectoryListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.filteredAndSortedResults.isEmpty {
                emptyState
            } else {
                List(viewModel.filteredAndSortedResults, selection: $viewModel.selectedDirectories) { directory in
                    DirectoryRowView(
                        directory: directory,
                        isSelected: viewModel.selectedDirectories.contains(directory.id)
                    )
                    .tag(directory.id)
                }
                .listStyle(.plain)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: viewModel.settingsStore.scanDirectories.isEmpty ? "folder.badge.plus" : "folder.badge.magnifyingglass")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.accentColor)
            }
            
            VStack(spacing: 8) {
                Text(viewModel.settingsStore.scanDirectories.isEmpty ? "No Scan Directories Configured" : "No Package Directories Found")
                    .font(.system(size: 20, weight: .semibold))
                
                Text(viewModel.settingsStore.scanDirectories.isEmpty 
                     ? "Add directories to scan in Settings (⌘,) to get started"
                     : "Click 'Scan' to search for package directories")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if viewModel.settingsStore.scanDirectories.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("For best results, add specific directories like ~/Projects or ~/Developer")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(nsColor: .controlBackgroundColor))
                )
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Package Cleaner finds node_modules, vendor, and other dependency folders")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(nsColor: .controlBackgroundColor))
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}
