import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings

    private let babyBlue = Color(red: 0.68, green: 0.85, blue: 0.96)

    var body: some View {
        NavigationView {
            Form {
                Section("notifications") {
                    Toggle("sunscreen reminders", isOn: $settings.notificationsEnabled)
                        .font(.custom("PatrickHand-Regular", size: 17))
                        .tint(babyBlue)
                }

                // temperature threshold section
                Section("temperature threshold") {
                    // slider to pick the temp that triggers a reminder
                    VStack(alignment: .leading) {
                        Text("remind me above \(Int(settings.temperatureThreshold))°c")
                            .font(.custom("PatrickHand-Regular", size: 17))
                        Slider(value: $settings.temperatureThreshold, in: 20...45, step: 1)
                            .tint(babyBlue)
                    }
                }

                // about section
                Section("about") {
                    Text("sunny helps you remember sunscreen on hot days")
                        .font(.custom("PatrickHand-Regular", size: 15))
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(babyBlue.opacity(0.15))
            .navigationTitle("settings")
        }
        .tint(babyBlue)
    }
}
