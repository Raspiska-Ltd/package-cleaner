import SwiftUI

struct DirectoryRowView: View {
    let directory: PackageDirectory
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: directory.language.iconName)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(
                    LinearGradient(
                        colors: [languageColor, languageColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
                .shadow(color: languageColor.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(directory.projectName)
                    .font(.system(size: 14, weight: .semibold))
                
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(directory.projectPath.path)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(directory.type.displayName)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(Color.accentColor)
                            )
                        
                        Text(directory.language.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(directory.size.formattedByteCount)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text(directory.lastActivity.timeAgoDisplay())
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(ageColor)
                            .frame(width: 6, height: 6)
                        Text("\(directory.ageInDays) days")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(ageColor)
                    }
                }
                .frame(width: 140)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor.opacity(0.08) : Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 6 : 2, x: 0, y: 2)
    }
    
    private var languageColor: Color {
        switch directory.language {
        case .javascript, .typescript: return .yellow
        case .php: return .purple
        case .java, .kotlin: return .orange
        case .rust: return .red
        case .swift: return .orange
        case .python: return .blue
        case .dart: return .cyan
        case .ruby: return .red
        case .go: return .cyan
        case .dotnet: return .purple
        case .unknown: return .gray
        }
    }
    
    private var ageColor: Color {
        if directory.ageInDays > 365 {
            return .red
        } else if directory.ageInDays > 180 {
            return .orange
        } else if directory.ageInDays > 90 {
            return .yellow
        } else {
            return .green
        }
    }
}
