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
            Image(systemName: reminder.isCompleted ? "largecircle.fill.circle" : "circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    reminder.isCompleted.toggle()
                }
            VStack(alignment: .leading) {
                Text(reminder.title)
                if !reminder.description.isEmpty {
                    Text(reminder.description)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                if reminder.isDueDateInitialized {
                    Text(reminder.formattedDueDate)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }
}

enum ReminderCellEvents {
    case onChecked(Reminder, Bool)
    case onSelect(Reminder)
    case onInfoSelect(Reminder)
}

#Preview {
    ReminderCellView(reminder: mockData()[0])
}
