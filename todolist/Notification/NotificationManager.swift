import UserNotifications
import UIKit

// UIApplicationDelegate,  UNUserNotificationCenterDelegate 的方法都是在特定场景被自动调用的, 我们只需要写好方法体内的逻辑就好了
final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - UIApplicationDelegate
    
    // 应用 launch (杀后台再进) 时被调用, 从后台切入不会被调用
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 这行代码很重要,
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("aaa")
        NotificationManager.clearBadges()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Tells the delegate how to handle a notification that arrived while the app was running in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // In App, no sound, just banner.
        completionHandler([.banner])
    }
    
    // When there is a notification, and user click the notification, this function will be called.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

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
