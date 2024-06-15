//
//  Reminder.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import Foundation

// 必须使用 @Observable, 否则绑定属性不会生效 (子view无法修改来自父view的数据
@Observable class Reminder: Identifiable {
    let id: UUID = UUID()
    
    var title = ""
    var description = ""
    var dueDate: Date = .distantFuture
    var repeatingDays: Set<Weekday> = []
    var isCompleted: Bool = false
}

extension Reminder {
    var text: String {
        let daysText = repeatingDays.map{$0.name}.joined(separator: ", ")
        return "Every Week on " + daysText
    }
}

enum Weekday: CaseIterable, Identifiable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

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
