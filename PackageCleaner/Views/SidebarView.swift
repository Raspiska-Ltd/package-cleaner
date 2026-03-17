import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isFiltersExpanded = true
    @State private var isPackageTypesExpanded = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(spacing: 8) {
                    actionButton(
                        title: "Select All",
                        icon: "checkmark.circle.fill",
                        color: .blue,
                        action: viewModel.selectAll,
                        disabled: viewModel.filteredAndSortedResults.isEmpty
                    )
                    
                    actionButton(
                        title: "Deselect All",
                        icon: "circle",
                        color: .gray,
                        action: viewModel.deselectAll,
                        disabled: viewModel.selectedDirectories.isEmpty
                    )
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                
                Divider()
                    .padding(.horizontal, 16)
                
                AccordionSection(
                    title: "Filters",
                    icon: "line.3.horizontal.decrease.circle.fill",
                    isExpanded: $isFiltersExpanded
                ) {
                    VStack(spacing: 4) {
                        filterButton(
                            title: "All Languages",
                            icon: "globe",
                            isSelected: viewModel.filterLanguage == nil,
                            action: { viewModel.filterLanguage = nil }
                        )
                        
                        ForEach(Language.allCases.filter { $0 != .unknown }) { language in
                            filterButton(
                                title: language.displayName,
                                icon: language.iconName,
                                isSelected: viewModel.filterLanguage == language,
                                action: { viewModel.filterLanguage = language }
                            )
                        }
                    }
                    .padding(.bottom, 12)
                }
                
                Divider()
                    .padding(.horizontal, 16)
                
                AccordionSection(
                    title: "Package Types",
                    icon: "shippingbox.fill",
                    isExpanded: $isPackageTypesExpanded
                ) {
                    VStack(spacing: 4) {
                        filterButton(
                            title: "All Types",
                            icon: "square.stack.3d.up.fill",
                            isSelected: viewModel.filterPackageType == nil,
                            action: { viewModel.filterPackageType = nil }
                        )
                        
                        ForEach(PackageType.allCases) { type in
                            filterButton(
                                title: type.displayName,
                                icon: "folder.fill",
                                isSelected: viewModel.filterPackageType == type,
                                action: { viewModel.filterPackageType = type }
                            )
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
            .padding(.bottom, 16)
        }
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }
    
    private func filterButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void, disabled: Bool) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(disabled ? .secondary : color)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(disabled ? .secondary : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(disabled ? Color.gray.opacity(0.1) : color.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(disabled ? Color.clear : color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}
