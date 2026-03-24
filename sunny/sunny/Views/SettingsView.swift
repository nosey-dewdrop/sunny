import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: UserSettings

    private let accentBlue = Color.blue.opacity(0.6)

    var body: some View {
        NavigationView {
            Form {
                Section("notifications") {
                    Toggle("sunscreen reminders", isOn: $settings.notificationsEnabled)
                        .font(.custom("PatrickHand-Regular", size: 17))
                        .tint(accentBlue)

                    Toggle("repeating reminders", isOn: $settings.repeatingReminders)
                        .font(.custom("PatrickHand-Regular", size: 17))
                        .tint(accentBlue)
                        .onChange(of: settings.repeatingReminders) {
                            if settings.repeatingReminders {
                                NotificationManager.shared.scheduleRepeatingReminders(everyHours: Int(settings.reminderInterval))
                            } else {
                                NotificationManager.shared.cancelRepeatingReminders()
                            }
                        }

                    if settings.repeatingReminders {
                        VStack(alignment: .leading) {
                            Text("every \(Int(settings.reminderInterval)) hours")
                                .font(.custom("PatrickHand-Regular", size: 17))
                            Slider(value: $settings.reminderInterval, in: 1...6, step: 1)
                                .tint(accentBlue)
                                .onChange(of: settings.reminderInterval) {
                                    NotificationManager.shared.scheduleRepeatingReminders(everyHours: Int(settings.reminderInterval))
                                }
                        }
                    }
                }

                // temperature threshold section
                Section("temperature threshold") {
                    // slider to pick the temp that triggers a reminder
                    VStack(alignment: .leading) {
                        Text("remind me above \(Int(settings.temperatureThreshold))°c")
                            .font(.custom("PatrickHand-Regular", size: 17))
                        Slider(value: $settings.temperatureThreshold, in: 20...45, step: 1)
                            .tint(accentBlue)
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
            .background(accentBlue.opacity(0.1))
            .navigationTitle("settings")
        }
        .tint(accentBlue)
    }
}
