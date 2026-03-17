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
}
