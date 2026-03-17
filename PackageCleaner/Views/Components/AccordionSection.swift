import SwiftUI

struct AccordionSection<Content: View>: View {
    let title: String
    let icon: String
    @Binding var isExpanded: Bool
    let content: Content
    
    init(
        title: String,
        icon: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 14))
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
