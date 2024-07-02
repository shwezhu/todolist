import UserNotifications
import UIKit

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    // Singleton Pattern
    static let shared = NotificationManager()
    
    private var notificationCount = 0 {
        didSet {
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().setBadgeCount(self.notificationCount) { error in
                    if let error = error {
                        print("Failed to set badge count: \(error)")
                    }
                }
            }
        }
    }
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
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
        
        let content = UNMutableNotificationContent()
        content.title = "有任务要做啦"
        content.body = reminder.title
        content.sound = .default
        
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
        shared.notificationCount = 0
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // When app is running in the foreground, will run this code.
        if UIApplication.shared.applicationState == .active {
            completionHandler([.banner])
        } else {
            self.notificationCount += 1
            completionHandler([.banner, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // When there is a notification, and user click the notification, will run this code.
        completionHandler()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    // 应用 launch 时被调用
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 清空 Badges
        NotificationManager.clearBadges()
        // 确保 NotificationManager.shared 被初始化
        _ = NotificationManager.shared
        return true
    }
}
