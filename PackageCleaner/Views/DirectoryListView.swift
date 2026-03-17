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
        VStack(spacing: 16) {
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Package Directories Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Click 'Scan' to search for package directories")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
