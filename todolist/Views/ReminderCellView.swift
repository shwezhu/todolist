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
    var onDropped: () -> Void
    
    var isOverdue: Bool {
        guard let dueDate = reminder.dueDate else { return false }
        // completedAt: 无论完成或被 dropped 的时间
        return reminder.completedAt == nil && dueDate < Date()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: reminder.completedAt == nil ? "circle" : "largecircle.fill.circle")
                .imageScale(.large)
                .foregroundStyle(isOverdue ? Color.red : (reminder.isDropped ? Color.gray : Color.blue))
                .matchedGeometryEffect(id: "icon_\(reminder.id)", in: namespace)
                .onTapGesture(perform: onToggle)
            VStack(alignment: .leading) {
                Text(reminder.title)
                    .foregroundStyle(reminder.isDropped ? Color.gray : (isOverdue ? Color.red : Color.black))
                    .strikethrough(reminder.isDropped)
                    .matchedGeometryEffect(id: "title_\(reminder.id)", in: namespace)
                if !reminder.notes.isEmpty {
                    Text(reminder.notes)
                        .font(.subheadline)
                        .foregroundStyle(isOverdue ? Color.red.opacity(0.6) : Color.gray)
                        .matchedGeometryEffect(id: "notes_\(reminder.id)", in: namespace)
                }
                if reminder.dueDate != nil {
                    Text(reminder.formattedDueDate)
                        .font(.subheadline)
                        .foregroundStyle(isOverdue ? Color.red.opacity(0.6) : Color.gray)
                        .matchedGeometryEffect(id: "dueDate_\(reminder.id)", in: namespace)
                }
            }
            Spacer()
            // 使用 Button 点击不会生效, 因为 ReminderCellView 在 NavigationLink 内
            Image(systemName: "flag.slash")
                .imageScale(.large)
                .foregroundStyle(reminder.completedAt != nil ? Color.gray : Color.orange)
                .onTapGesture(perform: onDropped)
        }
        .padding()
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
    } onDropped: {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            reminder.completedAt = reminder.completedAt == nil ? Date() : nil
        }
    }
        .modelContainer(container)
}
