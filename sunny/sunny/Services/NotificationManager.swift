import UserNotifications
import os

private let logger = Logger(subsystem: "com.damla.sunny", category: "NotificationManager")

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                logger.error("Notification permission error: \(error.localizedDescription)")
            }
            logger.info("Notification permission granted: \(granted)")
        }
    }

    // show notifications even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    func sendSunscreenReminder(temp: Double) {
        // validate temperature is within reasonable range
        guard temp.isFinite, temp > -100, temp < 70 else {
            logger.warning("Invalid temperature value: \(temp), skipping notification")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "sunscreen time! ☀️"
        content.body = "it's \(Int(temp))° outside - don't forget your sunscreen!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "sunscreen-reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // schedules repeating reminders between 08:00-20:00 at given interval
    func scheduleRepeatingReminders(everyHours interval: Int = 2) {
        let center = UNUserNotificationCenter.current()

        // remove all old reminders first
        let allIds = (8...20).map { "sunscreen-repeat-\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: allIds)

        var hour = 8
        while hour <= 20 {
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
            hour += interval
        }
    }

    // cancels all repeating reminders
    func cancelRepeatingReminders() {
        let allIds = (8...20).map { "sunscreen-repeat-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allIds)
    }
}
