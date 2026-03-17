import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage("temperatureThreshold") var temperatureThreshold: Double = 30.0
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("repeatingReminders") var repeatingReminders: Bool = false
}
