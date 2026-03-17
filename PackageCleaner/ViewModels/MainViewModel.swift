import Foundation
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var scanResults: [PackageDirectory] = []
    @Published var selectedDirectories: Set<PackageDirectory.ID> = []
    @Published var isScanning = false
    @Published var scanProgress: ScanProgress?
    @Published var filterLanguage: Language?
    @Published var filterPackageType: PackageType?
    @Published var searchText = ""
    @Published var sortOption: SortOption = .size
    @Published var errorMessage: String?
    
    private let scannerService: ScannerServiceProtocol
    private let settingsStore: SettingsStore
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
        settingsStore: SettingsStore = SettingsStore()
    ) {
        self.scannerService = scannerService
        self.settingsStore = settingsStore
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
            results.sort { $0.projectName.localizedCompare($1.projectName) == .orderedAscending }
        case .size:
            results.sort { $0.size > $1.size }
        case .date:
            results.sort { $0.lastActivity > $1.lastActivity }
        case .language:
            results.sort { $0.language.displayName.localizedCompare($1.language.displayName) == .orderedAscending }
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
                    progress: { [weak self] progress in
                        Task { @MainActor in
                            self?.scanProgress = progress
                        }
                    }
                )
                
                scanResults = results
                
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
    }
}
