import SwiftUI

struct DirectoryRowView: View {
    let directory: PackageDirectory
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: directory.language.iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(directory.projectName)
                    .font(.headline)
                
                Text(directory.projectPath.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text(directory.type.displayName)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(4)
                    
                    Text(directory.language.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                SizeLabel(size: directory.size)
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                DateLabel(date: directory.lastActivity, source: directory.project?.activitySource)
                
                Text("\(directory.ageInDays) days")
                    .font(.caption)
                    .foregroundColor(directory.ageInDays > 180 ? .orange : .secondary)
            }
            .frame(width: 150)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(6)
    }
}
