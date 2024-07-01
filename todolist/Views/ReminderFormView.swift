//
//  ReminderFormView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-18.
//

import SwiftUI
import SwiftData

struct ReminderFormView: View {
    @Bindable var reminder: Reminder
    @State private var isDueDateSet: Bool
    
    init(reminder: Reminder) {
        self.reminder = reminder
        self._isDueDateSet = State(initialValue: reminder.dueDate != nil)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $reminder.title)
                TextField("Description", text: $reminder.notes, axis: .vertical)
                    .lineLimit(3...4)
            }
            Section {
                Toggle(isOn: $isDueDateSet) {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                        .foregroundStyle(Color.red)
                }
                .tint(Color.green)
                .onChange (of: isDueDateSet) {
                    if isDueDateSet {
                        reminder.dueDate = Date()
                    } else {
                        reminder.dueDate = nil
                    }
                }
                if isDueDateSet {
                    DatePicker("Due Date",
                               selection: Binding(
                                get: { reminder.dueDate ?? Date() },
                                    set: {reminder.dueDate = $0}
                               ),
                               displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            
            if isDueDateSet {
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
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)
    let reminder = Reminder()
    
    return ReminderFormView(reminder: reminder)
        .modelContainer(container)
}
