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
    var description: String = ""
    var dueDate: Date = .distantFuture {
        didSet {
            isDueDateInitialized = true
        }
    }
    var isDueDateInitialized: Bool = false
    var repeatingDays: Set<Weekday> = []
    var isCompleted: Bool = false
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
        
        if calendar.isDateInToday(dueDate) {
            dateFormatter.dateFormat = "'Today,' h:mm a"
        } else if calendar.isDateInTomorrow(dueDate) {
            dateFormatter.dateFormat = "'Tomorrow,' h:mm a"
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        }
        
        return dateFormatter.string(from: dueDate)
    }
}

enum Weekday: CaseIterable, Identifiable {
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
