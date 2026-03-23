import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @ObservedObject var settingsStore: SettingsStore
    @Published var showingDirectoryPicker = false
    
    init(settingsStore: SettingsStore = .shared) {
        self.settingsStore = settingsStore
    }
    
    func addScanDirectory(_ url: URL) {
        if !settingsStore.scanDirectories.contains(url) {
            settingsStore.scanDirectories.append(url)
            settingsStore.save()
        }
    }
    
    func removeScanDirectory(at offsets: IndexSet) {
        objectWillChange.send()
        settingsStore.objectWillChange.send()
        settingsStore.scanDirectories.remove(atOffsets: offsets)
        settingsStore.save()
    }
    
    func addExcludedPath(_ path: String) {
        if !settingsStore.excludedPaths.contains(path) {
            settingsStore.excludedPaths.append(path)
            settingsStore.save()
        }
    }
    
    func removeExcludedPath(at offsets: IndexSet) {
        settingsStore.excludedPaths.remove(atOffsets: offsets)
        settingsStore.save()
    }
    
    func togglePackageType(_ type: PackageType) {
        if settingsStore.enabledPackageTypes.contains(type) {
            settingsStore.enabledPackageTypes.remove(type)
        } else {
            settingsStore.enabledPackageTypes.insert(type)
        }
        settingsStore.save()
    }
    
    func saveSettings() {
        settingsStore.save()
    }
    
    func resetToDefaults() {
        settingsStore.resetToDefaults()
    }
}
