//
//  NotificationManager.swift
//  todolist
//
//  Created by David Zhu on 2024-06-23.
//

import UserNotifications

final class NotificationManager {
    // Singleton Pattern
    static let shared = NotificationManager()
    private var notificationCount = 0 {
        didSet {
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().setBadgeCount(self.notificationCount)
            }
        }
    }
    
    static func requestNotificationPermission() {
        //  UNUserNotificationCenter.current() 是一个全局单例, 无论你在哪里或何时调用它, 总是返回相同的实例
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                return
            } else if let err = error {
                print("Failed to request notification auhtorization: \(err)")
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
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
