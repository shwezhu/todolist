//
//  ReminderCellView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-15.
//

import SwiftUI
import SwiftData

struct ReminderCellView: View {
    @Bindable var reminder: Reminder
    var namespace: Namespace.ID
    var onToggle: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminder.completedAt == nil ? "circle" : "largecircle.fill.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .matchedGeometryEffect(id: "icon_\(reminder.id)", in: namespace)
                .onTapGesture(perform: onToggle)
            VStack(alignment: .leading) {
                Text(reminder.title)
                    .matchedGeometryEffect(id: "title_\(reminder.id)", in: namespace)
                if !reminder.notes.isEmpty {
                    Text(reminder.notes)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .matchedGeometryEffect(id: "notes_\(reminder.id)", in: namespace)
                }
                if reminder.dueDate != nil {
                    Text(reminder.formattedDueDate)
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                        .matchedGeometryEffect(id: "dueDate_\(reminder.id)", in: namespace)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)
    let reminder = Reminder(title: "buy cook")
    @Namespace var animation
    
    return ReminderCellView(reminder: reminder, namespace: animation) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            reminder.completedAt = reminder.completedAt == nil ? Date() : nil
        }
    }
        .modelContainer(container)
}
