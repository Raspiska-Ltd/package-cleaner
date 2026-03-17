import SwiftUI

struct DateLabel: View {
    let date: Date
    let source: ActivitySource?
    
    init(date: Date, source: ActivitySource? = nil) {
        self.date = date
        self.source = source
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(date.timeAgoDisplay())
                .foregroundColor(.secondary)
            
            if let source = source {
                Text("(\(source.displayName))")
                    .font(.caption)
                    .foregroundColor(.tertiary)
            }
        }
    }
}
