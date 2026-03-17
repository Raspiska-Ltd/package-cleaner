import SwiftUI

@main
struct PackageCleanerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        
        Settings {
            SettingsView(viewModel: SettingsViewModel())
        }
    }
}
