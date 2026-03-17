import SwiftUI

struct ToolbarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var cleanupViewModel: CleanupViewModel
    @Binding var showingSettings: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 10) {
                ModernButton("Scan", icon: "magnifyingglass.circle.fill", style: .primary) {
                    mainViewModel.startScan()
                }
                .disabled(mainViewModel.isScanning)
                .keyboardShortcut("r", modifiers: .command)
                
                Menu {
                    ForEach(MainViewModel.SortOption.allCases, id: \.self) { option in
                        Button(action: { mainViewModel.sortOption = option }) {
                            HStack {
                                Image(systemName: option.systemImage)
                                Text(option.rawValue)
                                if mainViewModel.sortOption == option {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: mainViewModel.sortOption.systemImage)
                            .font(.system(size: 13, weight: .medium))
                        Text("Sort")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
                }
                .menuStyle(.borderlessButton)
            }
            
            Divider()
                .frame(height: 24)
            
            HStack(spacing: 10) {
                ModernButton("Delete", icon: "trash.fill", style: .destructive) {
                    cleanupViewModel.requestDeletion(
                        directories: mainViewModel.selectedDirectoriesArray,
                        onComplete: mainViewModel.removeDeletedDirectories
                    )
                }
                .disabled(mainViewModel.selectedDirectories.isEmpty || cleanupViewModel.isDeleting)
                .keyboardShortcut(.delete, modifiers: .command)
                
                if !mainViewModel.autoCleanupCandidates.isEmpty {
                    ModernButton("Auto-Cleanup", icon: "sparkles", style: .primary) {
                        mainViewModel.selectAutoCleanupCandidates()
                        cleanupViewModel.requestDeletion(
                            directories: mainViewModel.autoCleanupCandidates,
                            onComplete: mainViewModel.removeDeletedDirectories
                        )
                    }
                    .disabled(cleanupViewModel.isDeleting)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                if !mainViewModel.scanResults.isEmpty {
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Found",
                            value: "\(mainViewModel.filteredAndSortedResults.count)",
                            icon: "folder.fill",
                            color: .blue
                        )
                        .frame(width: 140)
                        
                        StatCard(
                            title: "Total Size",
                            value: mainViewModel.totalSize.formattedByteCount,
                            icon: "internaldrive.fill",
                            color: .purple
                        )
                        .frame(width: 140)
                    }
                }
                
                SearchBar(text: $mainViewModel.searchText, placeholder: "Search projects...")
                    .frame(width: 220)
                
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(",", modifiers: .command)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
