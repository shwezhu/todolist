//
//  AppDelegate.swift
//  todolist
//
//  Created by David Zhu on 2024-07-03.
//

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
