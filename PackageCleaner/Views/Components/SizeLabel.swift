import SwiftUI

struct SizeLabel: View {
    let size: Int64
    
    var body: some View {
        Text(size.formattedByteCount)
            .font(.system(.body, design: .monospaced))
            .foregroundColor(.secondary)
    }
}
