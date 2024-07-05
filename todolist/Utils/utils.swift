//
//  utils.swift
//  todolist
//
//  Created by David Zhu on 2024-06-23.
//

import Foundation
import SwiftData

func calculateNextDueDate(from date: Date, repeatingDays: Set<Weekday>) -> Date? {
    guard !repeatingDays.isEmpty else { return nil }
    
    let sortedDays = repeatingDays.sorted { $0.rawValue < $1.rawValue }
    
    // Calendar.current 返回当前用户设备上设置的日历系统 Calendar 对象
    let calendar = Calendar.current
    // calendar.component(.weekday, ...) returns an integer representing the day of the week for the provided date.
    // Sunday = 1, Monday = 2, ..
    let weekday = calendar.component(.weekday, from: date)
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    
    // 检查本周剩余日期
    if let nextDate = findNextDate(in: sortedDays, after: weekday, startingFrom: date, using: calendar) {
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: nextDate)
    }
    
    // 如果本周没有找到，则直接返回sortedDays中的第一个值在下周的日子
    // 周日 = 1, 周一 = 2, 一共为7, 7 - weekday + sortedDays[0].rawValue 即为当前日子到下次重复日期的距离
    let nextWeekStart = calendar.date(byAdding: .day, value: 7 - weekday + sortedDays[0].rawValue, to: date)!
    return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: nextWeekStart)
}

private func findNextDate(in days: [Weekday], after weekday: Int, startingFrom date: Date, using calendar: Calendar) -> Date? {
    for day in days where day.rawValue > weekday {
        if let nextDate = calendar.nextDate(after: date, matching: DateComponents(weekday: day.rawValue), matchingPolicy: .nextTimePreservingSmallerComponents) {
            return nextDate
        }
    }
    return nil
}

func createNextRepeatingReminder(for reminder: Reminder) -> Reminder? {
    guard let dueDate = reminder.dueDate,
          let nextDueDate = calculateNextDueDate(from: dueDate, repeatingDays: reminder.repeatingDays) else {
        return nil
    }
    
    return Reminder(
        title: reminder.title,
        notes: reminder.notes,
        repeatingDays: reminder.repeatingDays,
        dueDate: nextDueDate
    )
}

enum ReminderToggleAction {
    case completion
    case drop
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
