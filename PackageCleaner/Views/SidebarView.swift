import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Filters")
                .font(.headline)
                .padding()
            
            Divider()
            
            List {
                Section("Language") {
                    Button(action: { viewModel.filterLanguage = nil }) {
                        HStack {
                            Text("All Languages")
                            Spacer()
                            if viewModel.filterLanguage == nil {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(Language.allCases.filter { $0 != .unknown }) { language in
                        Button(action: { viewModel.filterLanguage = language }) {
                            HStack {
                                Image(systemName: language.iconName)
                                Text(language.displayName)
                                Spacer()
                                if viewModel.filterLanguage == language {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Section("Package Type") {
                    Button(action: { viewModel.filterPackageType = nil }) {
                        HStack {
                            Text("All Types")
                            Spacer()
                            if viewModel.filterPackageType == nil {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(PackageType.allCases) { type in
                        Button(action: { viewModel.filterPackageType = type }) {
                            HStack {
                                Text(type.displayName)
                                Spacer()
                                if viewModel.filterPackageType == type {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Section("Quick Actions") {
                    Button(action: viewModel.selectAll) {
                        Label("Select All", systemImage: "checkmark.circle")
                    }
                    .disabled(viewModel.filteredAndSortedResults.isEmpty)
                    
                    Button(action: viewModel.deselectAll) {
                        Label("Deselect All", systemImage: "circle")
                    }
                    .disabled(viewModel.selectedDirectories.isEmpty)
                    
                    Button(action: viewModel.selectAutoCleanupCandidates) {
                        Label("Select Old Projects", systemImage: "clock.badge.exclamationmark")
                    }
                    .disabled(viewModel.autoCleanupCandidates.isEmpty)
                }
            }
            .listStyle(.sidebar)
        }
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
    }
}
