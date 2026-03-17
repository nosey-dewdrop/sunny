import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings

    var body: some View {
        NavigationView {
            Form {
                Section("notifications") {
                    Toggle("sunscreen reminders", isOn: $settings.notificationsEnabled)
                }

                // temperature threshold section
                Section("temperature threshold") {
                    // slider to pick the temp that triggers a reminder
                    VStack(alignment: .leading) {
                        Text("remind me above \(Int(settings.temperatureThreshold))°c")
                            .font(.body)
                        Slider(value: $settings.temperatureThreshold, in: 20...45, step: 1)
                    }
                }

                // about section
                Section("about") {
                    Text("sunny helps you remember sunscreen on hot days")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("settings")
        }
    }
}
