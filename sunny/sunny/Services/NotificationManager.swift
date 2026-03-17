import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func sendSunscreenReminder(temp: Double) {
        let content = UNMutableNotificationContent()
        content.title = "sunscreen time! ☀️"
        content.body = "it's \(Int(temp))° outside - don't forget your sunscreen!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "sunscreen-reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // schedules repeating reminders every 2 hours between 08:00-20:00
    func scheduleRepeatingReminders() {
        let center = UNUserNotificationCenter.current()

        // remove old repeating reminders first
        let ids = (8...18).filter { $0 % 2 == 0 }.map { "sunscreen-repeat-\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: ids)

        for hour in stride(from: 8, through: 18, by: 2) {
            let content = UNMutableNotificationContent()
            content.title = "sunscreen check! ☀️"
            content.body = "hey! have you reapplied your sunscreen? 🧴"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "sunscreen-repeat-\(hour)",
                content: content,
                trigger: trigger
            )

            center.add(request)
        }
    }

    // cancels all repeating reminders
    func cancelRepeatingReminders() {
        let ids = (8...18).filter { $0 % 2 == 0 }.map { "sunscreen-repeat-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
