//
//  ReminderCellView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-15.
//

import SwiftUI

struct ReminderCellView: View {
    let reminder: Reminder
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminder.completedDate == nil ? "largecircle.fill.circle" : "circle")
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
    ReminderCellView(reminder: Reminder())
}
