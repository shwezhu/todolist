//
//  AddReminderView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminder = Reminder()
    @State private var showCalendar = false
    
    private func commit() {
        
    }
    
    private func cancel() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $reminder.title)
                    TextField("Description", text: $reminder.description, axis: .vertical)
                        .lineLimit(3...4)
                }
                Section {
                    Toggle(isOn: $showCalendar) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                    }
                    .tint(.black)
                    if showCalendar {
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
            // 必须在 NavigationStack 里面, 否则按钮不会显示
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                  Button(action: cancel) {
                    Text("Cancel")
                  }
                }
                ToolbarItem(placement: .confirmationAction) {
                  Button(action: commit) {
                    Text("Add")
                  }
                  .disabled(reminder.title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddReminderView()
}

