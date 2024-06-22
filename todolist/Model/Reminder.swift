//
//  Reminder.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import Foundation
import SwiftData

// @Model also makes your class Observable.
// 必须使用 @Observable, 否则访问绑定属性不会生效
@Model
final class Reminder: Identifiable {
    let id: UUID
    
    var title: String
    var notes: String
    var repeatingDays: Set<Weekday>
    var dueDate: Date?
    var completedAt: Date?
    var createdAt: Date
    
    init(title: String = "", notes: String = "", repeatingDays: Set<Weekday> = [], dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.repeatingDays = repeatingDays
        self.dueDate = dueDate
        self.completedAt = nil
        self.createdAt = Date()
    }
}

enum Weekday: String, CaseIterable, Identifiable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Self { self }
}

extension Weekday {
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
    var repeatingText: String {
        let daysText = Weekday.allCases.filter { repeatingDays.contains($0) }.map { $0.name }.joined(separator: ", ")
        return "Every Week on " + daysText
    }
    
    var formattedDueDate: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let date = dueDate {
            if calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "'Today,' h:mm a"
            } else if calendar.isDateInTomorrow(date) {
                dateFormatter.dateFormat = "'Tomorrow,' h:mm a"
            } else {
                dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
            }
            return dateFormatter.string(from: date)
        }
        return ""
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
                SortDescriptor(\Reminder.completedAt, order: .forward),
                SortDescriptor(\Reminder.dueDate, order: .forward)
            ]
        case .filterScheduledReminder:
            predicater = #Predicate { $0.dueDate != nil && $0.completedAt == nil }
            sorter = [SortDescriptor(\Reminder.dueDate, order: .forward)]
        case .filterUnscheduledReminder:
            predicater = #Predicate { $0.dueDate == nil && $0.completedAt == nil }
            sorter = [SortDescriptor(\Reminder.createdAt, order: .forward)]
        case .filterFinishedReminder:
            predicater = #Predicate { $0.completedAt != nil }
            sorter = [SortDescriptor(\Reminder.completedAt, order: .forward)]
        case .filterUnfinishedReminder:
            predicater = #Predicate { $0.completedAt == nil }
            sorter = [SortDescriptor(\Reminder.dueDate, order: .forward)]
        }
        
        return (predicater, sorter)
    }
}

enum ReminderPredicate: String, CaseIterable, Identifiable {
    case filterAllReminder, filterScheduledReminder, filterUnscheduledReminder, filterFinishedReminder, filterUnfinishedReminder

    var id: Self { self }
}
