import SwiftUI

struct ResultsToolbarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var cleanupViewModel: CleanupViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12) {
                Text("\(mainViewModel.filteredAndSortedResults.count) projects")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text(mainViewModel.totalSize.formattedByteCount)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.purple)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
            
            Divider()
                .frame(height: 24)
            
            HStack(spacing: 8) {
                Button(action: mainViewModel.selectAll) {
                    VStack(spacing: 2) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(mainViewModel.filteredAndSortedResults.isEmpty ? .secondary : .blue)
                        Text("All")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .disabled(mainViewModel.filteredAndSortedResults.isEmpty)
                .help("Select All (⌘A)")
                
                Button(action: mainViewModel.deselectAll) {
                    VStack(spacing: 2) {
                        Image(systemName: "circle")
                            .font(.system(size: 18))
                            .foregroundColor(mainViewModel.selectedDirectories.isEmpty ? .secondary : .gray)
                        Text("None")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .disabled(mainViewModel.selectedDirectories.isEmpty)
                .help("Deselect All")
                
                if !mainViewModel.autoCleanupCandidates.isEmpty {
                    Button(action: mainViewModel.selectAutoCleanupCandidates) {
                        VStack(spacing: 2) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 18))
                                .foregroundColor(.orange)
                            Text("Old")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .help("Select Old Projects")
                }
            }
            
            Divider()
                .frame(height: 24)
            
            Menu {
                Button(action: { mainViewModel.filterLanguage = nil }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("All Languages")
                        if mainViewModel.filterLanguage == nil {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Divider()
                
                ForEach(Language.allCases.filter { $0 != .unknown }) { language in
                    Button(action: { mainViewModel.filterLanguage = language }) {
                        HStack {
                            Image(systemName: language.iconName)
                            Text(language.displayName)
                            if mainViewModel.filterLanguage == language {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: mainViewModel.filterLanguage?.iconName ?? "line.3.horizontal.decrease.circle")
                        .font(.system(size: 13, weight: .medium))
                    Text(mainViewModel.filterLanguage?.displayName ?? "Language")
                        .font(.system(size: 13, weight: .medium))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(mainViewModel.filterLanguage != nil ? Color.accentColor.opacity(0.1) : Color(nsColor: .controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(mainViewModel.filterLanguage != nil ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }
            .menuStyle(.borderlessButton)
            
            Menu {
                Button(action: { mainViewModel.filterPackageType = nil }) {
                    HStack {
                        Image(systemName: "square.stack.3d.up.fill")
                        Text("All Types")
                        if mainViewModel.filterPackageType == nil {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Divider()
                
                ForEach(PackageType.allCases) { type in
                    Button(action: { mainViewModel.filterPackageType = type }) {
                        HStack {
                            Image(systemName: "folder.fill")
                            Text(type.displayName)
                            if mainViewModel.filterPackageType == type {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 13, weight: .medium))
                    Text(mainViewModel.filterPackageType?.displayName ?? "Type")
                        .font(.system(size: 13, weight: .medium))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(mainViewModel.filterPackageType != nil ? Color.accentColor.opacity(0.1) : Color(nsColor: .controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(mainViewModel.filterPackageType != nil ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
                )
            }
            .menuStyle(.borderlessButton)
            
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
                
                Divider()
                
                Button(action: { mainViewModel.sortAscending.toggle() }) {
                    HStack {
                        Image(systemName: mainViewModel.sortAscending ? "arrow.up" : "arrow.down")
                        Text(mainViewModel.sortAscending ? "Ascending" : "Descending")
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: mainViewModel.sortOption.systemImage)
                        .font(.system(size: 13, weight: .medium))
                    Text("Sort")
                        .font(.system(size: 13, weight: .medium))
                    Image(systemName: mainViewModel.sortAscending ? "arrow.up" : "arrow.down")
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(6)
            }
            .menuStyle(.borderlessButton)
            
            Spacer()
            
            ModernButton("Delete", icon: "trash.fill", style: .destructive) {
                cleanupViewModel.requestDeletion(
                    directories: mainViewModel.selectedDirectoriesArray,
                    onComplete: mainViewModel.removeDeletedDirectories
                )
            }
            .disabled(mainViewModel.selectedDirectories.isEmpty || cleanupViewModel.isDeleting)
            .keyboardShortcut(.delete, modifiers: .command)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }
}
