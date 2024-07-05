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
}

enum Weekday: Int, CaseIterable, Identifiable, Codable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var id: Self { self }
    
    var name: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

extension Reminder {
    public static func predicateFor(_ filter: ReminderPredicate) -> (Predicate<Reminder>?, [SortDescriptor<Reminder>]) {
        var predicater: Predicate<Reminder>?
        var sorter: [SortDescriptor<Reminder>]

        switch filter {
        case .filterAllReminder:
            predicater = nil
            sorter = [
                SortDescriptor(\Reminder.resolvedAt, order: .forward),
                SortDescriptor(\Reminder.dueDate, order: .forward),
                SortDescriptor(\Reminder.createdAt, order: .reverse),
            ]
        case .filterScheduledReminder:
            predicater = #Predicate { $0.dueDate != nil && $0.resolvedAt == nil }
            sorter = [SortDescriptor(\Reminder.dueDate, order: .forward)]
        case .filterUnscheduledReminder:
            predicater = #Predicate { $0.dueDate == nil && $0.resolvedAt == nil }
            sorter = [SortDescriptor(\Reminder.createdAt, order: .forward)]
        case .filterFinishedReminder:
            predicater = #Predicate { $0.resolvedAt != nil }
            sorter = [SortDescriptor(\Reminder.resolvedAt, order: .forward)]
        case .filterUnfinishedReminder:
            predicater = #Predicate { $0.resolvedAt == nil }
            sorter = [
                SortDescriptor(\Reminder.dueDate, order: .forward),
                SortDescriptor(\Reminder.createdAt, order: .reverse),
            ]
        }
        
        return (predicater, sorter)
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

enum ReminderPredicate: String, CaseIterable, Identifiable {
    case filterAllReminder, filterScheduledReminder, filterUnscheduledReminder, filterFinishedReminder, filterUnfinishedReminder

    var id: Self { self }
}
