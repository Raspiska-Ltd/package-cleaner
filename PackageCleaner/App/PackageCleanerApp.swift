import SwiftUI

@main
struct PackageCleanerApp: App {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var cleanupViewModel = CleanupViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(mainViewModel: mainViewModel, cleanupViewModel: cleanupViewModel, settingsViewModel: settingsViewModel)
                .frame(minWidth: 900, minHeight: 600)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        
        Settings {
            SettingsView(viewModel: settingsViewModel)
        }
    }
}
