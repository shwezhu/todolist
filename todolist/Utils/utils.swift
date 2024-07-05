//
//  utils.swift
//  todolist
//
//  Created by David Zhu on 2024-06-23.
//

import Foundation
import SwiftData

enum ReminderToggleAction {
    case completion
    case drop
}

func calculateNextDueDate(from date: Date, repeatingDays: Set<Weekday>) -> Date? {
    // Guard against empty repeatingDays set
    guard !repeatingDays.isEmpty else { return nil }
    
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
    
    // Sort the repeating days for efficient searching
    let sortedDays = repeatingDays.sorted { $0.rawValue < $1.rawValue }
    
    // Find the next due date within the current week
    if let nextDate = findNextDate(in: sortedDays, after: weekday, startingFrom: date, using: calendar) {
        return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                             minute: timeComponents.minute ?? 0,
                             second: 0,
                             of: nextDate)
    }
    
    // If no date found in the current week, find the first repeating day in the next week
    let daysUntilNextWeek = 7 - weekday + sortedDays[0].rawValue
    let nextWeekDate = calendar.date(byAdding: .day, value: daysUntilNextWeek, to: date)!
    
    return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                         minute: timeComponents.minute ?? 0,
                         second: 0,
                         of: nextWeekDate)
}

private func findNextDate(in days: [Weekday], after weekday: Int, startingFrom date: Date, using calendar: Calendar) -> Date? {
    // Find the first day that comes after the current weekday
    let nextDay = days.first { $0.rawValue > weekday }
    
    // If found, calculate the next occurrence of that day
    if let nextDay = nextDay {
        return calendar.nextDate(after: date,
                                 matching: DateComponents(weekday: nextDay.rawValue),
                                 matchingPolicy: .nextTimePreservingSmallerComponents)
    }
    
    return nil
}

func createNextRepeatingReminder(for reminder: Reminder) -> Reminder? {
    guard let dueDate = reminder.dueDate,
          let nextDueDate = calculateNextDueDate(from: dueDate, repeatingDays: reminder.repeatingDays) else {
        return nil
    }
    
    return Reminder(original: reminder, newDueDate: nextDueDate)
}

func toggleReminderState(for reminder: Reminder, action: ReminderToggleAction, in context: ModelContext) {
    let oldRepeatingDays = reminder.repeatingDays
    
    performToggleAction(for: reminder, action: action)
    
    // 在清除重复日期之前处理重复提醒
    if (reminder.isCompleted || reminder.isDropped) && !oldRepeatingDays.isEmpty {
        handleRepeatingReminder(for: reminder, with: oldRepeatingDays, in: context)
    }
    
    updateNotification(for: reminder)
    saveContext(context)
}

private func performToggleAction(for reminder: Reminder, action: ReminderToggleAction) {
    switch action {
    case .completion:
        reminder.toggleCompletionStatus()
    case .drop:
        reminder.toggleDropStatus()
    }
}

private func handleRepeatingReminder(for reminder: Reminder, with oldRepeatingDays: Set<Weekday>, in context: ModelContext) {
    if let newReminder = createNextRepeatingReminder(for: reminder.copy(withRepeatingDays: oldRepeatingDays)) {
        context.insert(newReminder)
    }
}

private func updateNotification(for reminder: Reminder) {
    if reminder.isDropped || reminder.isCompleted {
        NotificationManager.removeNotification(for: reminder)
        reminder.repeatingDays = []
    } else {
        NotificationManager.scheduleNotification(for: reminder)
    }
}

private func saveContext(_ context: ModelContext) {
    do {
        try context.save()
    } catch {
        print("Failed to save context: \(error)")
    }
}
