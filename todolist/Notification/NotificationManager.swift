import UIKit

final class NotificationManager: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                // print("Notification permission granted")
            } else if let err = error {
                print("Failed to request notification authorization: \(err)")
            }
        }
    }
    
    static func scheduleNotification(for reminder: Reminder) {
        guard let dueDate = reminder.dueDate else {
            return
        }
        
        let content = createNotificationContent(for: reminder)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification: \(error)")
            }
        }
    }
    
    static func removeNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
    
    static func updateNotification(for reminder: Reminder) {
        removeNotification(for: reminder)
        scheduleNotification(for: reminder)
    }
    
    static func clearBadges() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    private static func createNotificationContent(for reminder: Reminder) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "有任务要做啦"
        content.body = reminder.title
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        return content
    }
}
