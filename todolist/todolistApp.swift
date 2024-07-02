//
//  todolistApp.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import SwiftUI
import SwiftData

@main
struct todolistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var notificationDelegate
    
    init() {
        NotificationManager.requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
//                    NotificationManager.clearBadges()
//                }
        }
        .modelContainer(for: Reminder.self)
    }
}
