//
//  ReminderCellView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-15.
//

import SwiftUI
import SwiftData

struct ReminderCellView: View {
    let reminder: Reminder
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminder.completedDate == nil ? "circle" : "largecircle.fill.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    if reminder.completedDate == nil {
                        reminder.completedDate = Date()
                    } else {
                        reminder.completedDate = nil
                    }
                }
            VStack(alignment: .leading) {
                Text(reminder.title)
                if !reminder.notes.isEmpty {
                    Text(reminder.notes)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                if reminder.dueDate != nil {
                    Text(reminder.formattedDueDate)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)
    let reminder = Reminder(title: "buy cook")
    
    return ReminderCellView(reminder: reminder)
        .modelContainer(container)
}
