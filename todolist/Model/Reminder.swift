//
//  Reminder.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import Foundation
import SwiftData

// 必须使用 @Observable, 否则之后使用其绑定属性不会生效.
// @Model makes your class Observable already.
@Model
final class Reminder: Identifiable {
    let id: UUID
    var title: String
    var notes: String
    var repeatingDays: Set<Weekday>
    var dueDate: Date?
    
    var isCompleted: Bool
    var isDropped: Bool
    var isOverdue: Bool
    
    var createdAt: Date
    var resolvedAt: Date?
    
    init(title: String = "", notes: String = "", repeatingDays: Set<Weekday> = [], dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.repeatingDays = repeatingDays
        self.dueDate = dueDate
        
        self.isCompleted = false
        self.isDropped = false
        self.isOverdue = false
        
        self.createdAt = Date()
        self.resolvedAt = nil
    }
    
    // 用于创建重复提醒
    init(original: Reminder, newDueDate: Date) {
        self.id = UUID()
        self.title = original.title
        self.notes = original.notes
        self.repeatingDays = original.repeatingDays
        self.dueDate = newDueDate
        
        self.isCompleted = false
        self.isDropped = false
        self.isOverdue = false
        
        self.createdAt = Date()
        self.resolvedAt = nil
    }
}

enum Weekday: Int, CaseIterable, Identifiable, Codable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Self { self }
    
    // 使用静态数组来存储名称，提高性能
    private static let names = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var name: String {
        Weekday.names[self.rawValue - 1]
    }
}

extension Reminder {
    // 使用类型属性来缓存谓词，避免重复创建
    static let allReminderSorter = [
        SortDescriptor(\Reminder.resolvedAt, order: .forward),
        SortDescriptor(\Reminder.dueDate, order: .forward),
        SortDescriptor(\Reminder.createdAt, order: .reverse),
    ]
    
    static let scheduledReminderPredicate = #Predicate<Reminder> { $0.dueDate != nil && $0.resolvedAt == nil }
    static let unscheduledReminderPredicate = #Predicate<Reminder> { $0.dueDate == nil && $0.resolvedAt == nil }
    static let finishedReminderPredicate = #Predicate<Reminder> { $0.resolvedAt != nil }
    static let unfinishedReminderPredicate = #Predicate<Reminder> { $0.resolvedAt == nil }
    
    public static func predicateFor(_ filter: ReminderPredicate) -> (Predicate<Reminder>?, [SortDescriptor<Reminder>]) {
        switch filter {
        case .filterAllReminder:
            return (nil, allReminderSorter)
        case .filterScheduledReminder:
            return (scheduledReminderPredicate, [SortDescriptor(\Reminder.dueDate, order: .forward)])
        case .filterUnscheduledReminder:
            return (unscheduledReminderPredicate, [SortDescriptor(\Reminder.createdAt, order: .forward)])
        case .filterFinishedReminder:
            return (finishedReminderPredicate, [SortDescriptor(\Reminder.resolvedAt, order: .forward)])
        case .filterUnfinishedReminder:
            return (unfinishedReminderPredicate, allReminderSorter)
        }
    }
    
    func toggleCompletionStatus() {
        self.isCompleted = !self.isCompleted
        self.resolvedAt = self.isCompleted ? Date() : nil
        
        self.isDropped = false
    }
    
    func toggleDropStatus() {
        self.isDropped = !self.isDropped
        self.resolvedAt = self.isDropped ? Date() : nil
        
        self.isCompleted = false
    }
    
    func refreshOverdueStatus() {
        guard let dueDate = self.dueDate, self.resolvedAt == nil else { return }
        let currentDate = Date()
        self.isOverdue = dueDate < currentDate
    }
}

extension Reminder {
    func copy(withRepeatingDays repeatingDays: Set<Weekday>) -> Reminder {
        let copy = Reminder(
            title: self.title,
            notes: self.notes,
            repeatingDays: repeatingDays,
            dueDate: self.dueDate
        )
        copy.isCompleted = self.isCompleted
        copy.isDropped = self.isDropped
        copy.isOverdue = self.isOverdue
        copy.createdAt = self.createdAt
        copy.resolvedAt = self.resolvedAt
        return copy
    }
}

enum ReminderPredicate: String, CaseIterable, Identifiable {
    case filterAllReminder, filterScheduledReminder, filterUnscheduledReminder, filterFinishedReminder, filterUnfinishedReminder

    var id: Self { self }
}
