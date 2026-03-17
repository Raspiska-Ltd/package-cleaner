import SwiftUI

struct ProgressOverlay: View {
    let title: String
    let message: String
    let progress: Double?
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if let progress = progress {
                    ProgressView(value: progress)
                        .frame(width: 200)
                }
            }
            
            Button("Cancel", action: onCancel)
                .buttonStyle(.bordered)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(radius: 20)
        )
    }
}
