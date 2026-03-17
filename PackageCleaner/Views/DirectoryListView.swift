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
                
                Image(systemName: "folder.badge.magnifyingglass")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.accentColor)
            }
            
            VStack(spacing: 8) {
                Text("No Package Directories Found")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Click 'Scan' to search for package directories in your system")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}
