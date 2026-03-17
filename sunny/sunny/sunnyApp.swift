import SwiftUI

@main
struct sunnyApp: App {
    // ask for notification permission when app launches
    init() {
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
