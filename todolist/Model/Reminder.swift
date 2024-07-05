//
//  Reminder.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

// MARK: - Reminder.swift

import Foundation
import SwiftData

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

// MARK: - Reminder Extension

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
    
    static func predicateFor(_ filter: ReminderPredicate) -> (Predicate<Reminder>?, [SortDescriptor<Reminder>]) {
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
    
    // Methods
    func toggleCompletionStatus() {
        isCompleted.toggle()
        resolvedAt = isCompleted ? Date() : nil
        isDropped = false
    }
    
    func toggleDropStatus() {
        isDropped.toggle()
        resolvedAt = isDropped ? Date() : nil
        isCompleted = false
    }
    
    func refreshOverdueStatus() {
        guard let dueDate = dueDate, resolvedAt == nil else { return }
        isOverdue = dueDate < Date()
    }
    
    func copy(withRepeatingDays repeatingDays: Set<Weekday>) -> Reminder {
        Reminder(
            title: title,
            notes: notes,
            repeatingDays: repeatingDays,
            dueDate: dueDate
        )
    }
}

// MARK: - ReminderPredicate

enum ReminderPredicate: String, CaseIterable, Identifiable {
    case filterAllReminder, filterScheduledReminder, filterUnscheduledReminder, filterFinishedReminder, filterUnfinishedReminder

    var id: Self { self }
}

// MARK: - Weekday

enum Weekday: Int, CaseIterable, Identifiable, Codable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Self { self }
    
    // 使用静态数组来存储名称，提高性能
    private static let names = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var name: String {
        Weekday.names[rawValue - 1]
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
