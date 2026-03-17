import Foundation
import SwiftUI

@MainActor
class CleanupViewModel: ObservableObject {
    @Published var isDeleting = false
    @Published var cleanupProgress: CleanupProgress?
    @Published var showingConfirmation = false
    @Published var showingResult = false
    @Published var lastResult: CleanupResult?
    
    private let cleanupService: CleanupServiceProtocol
    private let settingsStore: SettingsStore
    private var cleanupTask: Task<Void, Never>?
    
    init(
        cleanupService: CleanupServiceProtocol = CleanupService(),
        settingsStore: SettingsStore = SettingsStore()
    ) {
        self.cleanupService = cleanupService
        self.settingsStore = settingsStore
    }
    
    func requestDeletion(
        directories: [PackageDirectory],
        onComplete: @escaping (Set<PackageDirectory.ID>) -> Void
    ) {
        guard !directories.isEmpty else { return }
        
        showingConfirmation = true
        
        cleanupTask = Task {
            await MainActor.run {
                showingConfirmation = false
            }
            
            guard !Task.isCancelled else { return }
            
            await performDeletion(directories: directories, onComplete: onComplete)
        }
    }
    
    func confirmDeletion(
        directories: [PackageDirectory],
        onComplete: @escaping (Set<PackageDirectory.ID>) -> Void
    ) {
        showingConfirmation = false
        
        cleanupTask = Task {
            await performDeletion(directories: directories, onComplete: onComplete)
        }
    }
    
    private func performDeletion(
        directories: [PackageDirectory],
        onComplete: @escaping (Set<PackageDirectory.ID>) -> Void
    ) async {
        isDeleting = true
        cleanupProgress = nil
        
        defer {
            isDeleting = false
            cleanupProgress = nil
        }
        
        do {
            let result = try await cleanupService.delete(
                directories: directories,
                moveToTrash: settingsStore.moveToTrash,
                progress: { [weak self] progress in
                    Task { @MainActor in
                        self?.cleanupProgress = progress
                    }
                }
            )
            
            lastResult = result
            showingResult = true
            
            let deletedIDs = Set(directories.prefix(result.successCount).map { $0.id })
            onComplete(deletedIDs)
            
        } catch {
            lastResult = CleanupResult(
                successCount: 0,
                failureCount: directories.count,
                totalFreedSpace: 0,
                errors: [.deletionFailed(directories[0].path, error)]
            )
            showingResult = true
        }
    }
    
    func cancelDeletion() {
        cleanupTask?.cancel()
        cleanupService.cancel()
        showingConfirmation = false
    }
}
