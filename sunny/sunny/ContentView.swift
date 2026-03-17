import SwiftUI

struct ContentView: View {
    // shared settings used by both tabs
    @StateObject private var settings = UserSettings()

    var body: some View {
        TabView {
            // main weather screen
            HomeView(settings: settings)
                .tabItem {
                    Label("home", systemImage: "sun.max.fill")
                }

            // settings screen
            SettingsView(settings: settings)
                .tabItem {
                    Label("settings", systemImage: "gearshape.fill")
                }
        }
    }
}
