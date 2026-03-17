import SwiftUI

struct ModernButton: View {
    let title: String
    let icon: String
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .accentColor
            case .secondary: return Color(nsColor: .controlBackgroundColor)
            case .destructive: return .red
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .primary
            case .destructive: return .white
            }
        }
    }
    
    init(_ title: String, icon: String, style: ButtonStyle = .secondary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}
