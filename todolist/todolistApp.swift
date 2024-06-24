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
    init() {
        NotificationManager.requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Reminder.self)
    }
}
