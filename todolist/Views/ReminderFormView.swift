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
            titleAndDescriptionSection
            dueDateSection
            if isDueDateSet {
                repeatSection
            }
        }
    }
    
    private var titleAndDescriptionSection: some View {
        Section {
            TextField("Title", text: $reminder.title)
            TextField("Description", text: $reminder.notes, axis: .vertical)
                .lineLimit(3...4)
        }
    }
    
    private var dueDateSection: some View {
        Section {
            Toggle(isOn: $isDueDateSet) {
                Label("Due Date", systemImage: "calendar")
                    .foregroundStyle(.red)
            }
            .tint(.green)
            .onChange(of: isDueDateSet) { oldValue, newValue in
                reminder.dueDate = newValue ? Date() : nil
            }
            
            if isDueDateSet {
                DatePicker("Due Date",
                           selection: Binding(
                            get: { reminder.dueDate ?? Date() },
                            set: { reminder.dueDate = $0 }
                           ),
                           displayedComponents: [.date, .hourAndMinute]
                )
            }
        }
    }
    
    private var repeatSection: some View {
        NavigationLink(destination: MultiWeekdayPicker(selectedDays: $reminder.repeatingDays)) {
            Label {
                Text("Repeat")
                Spacer()
                Text(repeatingDateText)
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: "repeat")
            }
        }
    }
    
    private var repeatingDateText: String {
        let daysText = Weekday.allCases.filter { reminder.repeatingDays.contains($0) }.map { $0.name }.joined(separator: ", ")
        return "Every week on " + daysText
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)
    let reminder = Reminder()
    
    return ReminderFormView(reminder: reminder)
        .modelContainer(container)
}
