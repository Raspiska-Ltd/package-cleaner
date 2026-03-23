import Foundation
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var scanResults: [PackageDirectory] = []
    @Published var selectedDirectories: Set<PackageDirectory.ID> = []
    @Published var isScanning = false
    @Published var scanProgress: ScanProgress?
    @Published var currentScanDirectory: String = ""
    @Published var filterLanguage: Language?
    @Published var filterPackageType: PackageType?
    @Published var searchText = ""
    @Published var sortOption: SortOption = .size
    @Published var sortAscending = false
    @Published var errorMessage: String?
    
    private let scannerService: ScannerServiceProtocol
    @ObservedObject var settingsStore: SettingsStore
    private var scanTask: Task<Void, Never>?
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case size = "Size"
        case date = "Last Activity"
        case language = "Language"
        
        var systemImage: String {
            switch self {
            case .name: return "textformat"
            case .size: return "arrow.up.arrow.down"
            case .date: return "calendar"
            case .language: return "chevron.left.forwardslash.chevron.right"
            }
        }
    }
    
    init(
        scannerService: ScannerServiceProtocol = ScannerService(),
        settingsStore: SettingsStore = .shared
    ) {
        self.scannerService = scannerService
        self.settingsStore = settingsStore
        
        loadCachedResults()
    }
    
    private func loadCachedResults() {
        let cached = PersistenceController.shared.loadScanResults()
        if !cached.isEmpty {
            scanResults = cached
        }
    }
    
    private func saveScanResults() {
        PersistenceController.shared.saveScanResults(scanResults)
    }
    
    var filteredAndSortedResults: [PackageDirectory] {
        var results = scanResults
        
        if let language = filterLanguage {
            results = results.filter { $0.language == language }
        }
        
        if let packageType = filterPackageType {
            results = results.filter { $0.type == packageType }
        }
        
        if !searchText.isEmpty {
            results = results.filter {
                $0.projectName.localizedCaseInsensitiveContains(searchText) ||
                $0.path.path.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOption {
        case .name:
            results.sort { 
                let comparison = $0.projectName.localizedCompare($1.projectName) == .orderedAscending
                return sortAscending ? comparison : !comparison
            }
        case .size:
            results.sort { sortAscending ? $0.size < $1.size : $0.size > $1.size }
        case .date:
            results.sort { sortAscending ? $0.lastActivity < $1.lastActivity : $0.lastActivity > $1.lastActivity }
        case .language:
            results.sort { 
                let comparison = $0.language.displayName.localizedCompare($1.language.displayName) == .orderedAscending
                return sortAscending ? comparison : !comparison
            }
        }
        
        return results
    }
    
    var selectedDirectoriesArray: [PackageDirectory] {
        scanResults.filter { selectedDirectories.contains($0.id) }
    }
    
    var totalSize: Int64 {
        scanResults.totalSize
    }
    
    var selectedSize: Int64 {
        selectedDirectoriesArray.totalSize
    }
    
    var autoCleanupCandidates: [PackageDirectory] {
        scanResults.filter { $0.isOlderThan(days: settingsStore.autoCleanupThresholdDays) }
    }
    
    func startScan() {
        // Validate scan directories are configured
        guard !settingsStore.scanDirectories.isEmpty else {
            errorMessage = "Please add scan directories in Settings before scanning"
            return
        }
        
        print("🔍 Starting scan with \(settingsStore.scanDirectories.count) directories:")
        for dir in settingsStore.scanDirectories {
            print("  📁 \(dir.path)")
        }
        
        scanTask?.cancel()
        
        scanTask = Task {
            isScanning = true
            scanProgress = nil
            errorMessage = nil
            scanResults = []
            selectedDirectories = []
            
            defer {
                isScanning = false
                scanProgress = nil
            }
            
            do {
                let results = try await scannerService.scan(
                    directories: settingsStore.scanDirectories,
                    packageTypes: settingsStore.enabledPackageTypes,
                    progress: { [weak self] progress, currentDir in
                        Task { @MainActor in
                            self?.scanProgress = progress
                            self?.currentScanDirectory = currentDir
                        }
                    }
                )
                
                scanResults = results
                currentScanDirectory = ""
                saveScanResults()
                
            } catch is CancellationError {
                errorMessage = "Scan cancelled"
            } catch {
                errorMessage = "Scan failed: \(error.localizedDescription)"
            }
        }
    }
    
    func cancelScan() {
        scanTask?.cancel()
        scannerService.cancel()
    }
    
    func selectAll() {
        selectedDirectories = Set(filteredAndSortedResults.map { $0.id })
    }
    
    func deselectAll() {
        selectedDirectories.removeAll()
    }
    
    func selectAutoCleanupCandidates() {
        selectedDirectories = Set(autoCleanupCandidates.map { $0.id })
    }
    
    func removeDeletedDirectories(_ deletedIDs: Set<PackageDirectory.ID>) {
        scanResults.removeAll { deletedIDs.contains($0.id) }
        selectedDirectories.subtract(deletedIDs)
        saveScanResults()
    }
    
    func clearResults() {
        scanResults.removeAll()
        selectedDirectories.removeAll()
        PersistenceController.shared.clearCache()
    }
}
