import SwiftUI

struct ScanToolbarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var showingSettings: Bool
    
    var body: some View {
        let _ = print("🔘 Scan button state - isEmpty: \(mainViewModel.settingsStore.scanDirectories.isEmpty), count: \(mainViewModel.settingsStore.scanDirectories.count)")
        
        HStack(spacing: 16) {
            ModernButton("Scan", icon: "magnifyingglass.circle.fill", style: .primary) {
                mainViewModel.startScan()
            }
            .disabled(mainViewModel.isScanning || mainViewModel.settingsStore.scanDirectories.isEmpty)
            .keyboardShortcut("r", modifiers: .command)
            .help(mainViewModel.settingsStore.scanDirectories.isEmpty ? "Add scan directories in Settings first" : "Scan for package directories (⌘R)")
            
            if !mainViewModel.scanResults.isEmpty && !mainViewModel.isScanning {
                Button(action: {
                    mainViewModel.clearResults()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                        Text("Clear")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .help("Clear all results")
            }
            
            if mainViewModel.isScanning {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.7)
                        .frame(width: 16, height: 16)
                    
                    Text("Scanning...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    if !mainViewModel.currentScanDirectory.isEmpty {
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(mainViewModel.currentScanDirectory)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    if let progress = mainViewModel.scanProgress {
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("\(progress.directoriesFound) found")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: 400)
            } else if !mainViewModel.scanResults.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(mainViewModel.settingsStore.scanDirectories.map { $0.lastPathComponent }.joined(separator: ", "))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .frame(maxWidth: 300)
            }
            
            Spacer()
            
            SearchBar(text: $mainViewModel.searchText, placeholder: "Search projects...")
                .frame(width: 250)
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(width: 32, height: 32)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(",", modifiers: .command)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
