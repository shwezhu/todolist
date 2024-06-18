//
//  ReminderFormView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-18.
//

import SwiftUI

struct ReminderFormView: View {
    @Bindable var reminder: Reminder
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $reminder.title)
                TextField("Description", text: $reminder.description, axis: .vertical)
                    .lineLimit(3...4)
            }
            Section {
                Toggle(isOn: $reminder.isDueDateInitialized) {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                }
                .tint(.black)
                if reminder.isDueDateInitialized {
                    DatePicker("Due Date",
                               selection: $reminder.dueDate,
                               displayedComponents: [.date, .hourAndMinute])
                }
            }
            NavigationLink(destination: MultiWeekdayPicker(selectedDays: $reminder.repeatingDays)) {
                HStack {
                    Image(systemName: "repeat")
                    Text("Repeat")
                    Spacer()
                    Text(reminder.repeatingDays.isEmpty ? "Never" : reminder.repeatingText)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }
}

#Preview {
    ReminderFormView(reminder: mockData()[0])
}
