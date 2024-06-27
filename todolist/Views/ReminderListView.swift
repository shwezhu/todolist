//
//  ReminderListView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-20.
//

import SwiftUI
import SwiftData

struct DummyView: View {
    var title: String
    var filter: ReminderPredicate
    var body: some View {
        ReminderListView(title: title, filter: filter)
    }
}

struct ReminderListView: View {
    @Environment(\.modelContext) var context
    @Query var reminders: [Reminder]
    @Namespace private var animation
    @State private var animationId = UUID()
    var title: String
    
    init(title: String = "Untitled", filter: ReminderPredicate) {
        self.title = title
        self._reminders = Query(filter: Reminder.predicateFor(filter).0, sort: Reminder.predicateFor(filter).1)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
                        ReminderCellView(reminder: reminder, namespace: animation) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                toggleReminderState(for: reminder, action: .completion, in: context)
                            }
                        } onDropped: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                toggleReminderState(for: reminder, action: .drop, in: context)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let reminder = reminders[index]
                        NotificationManager.removeNotification(for: reminder)
                        context.delete(reminder)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func deleteReminders(at offsets: IndexSet) {
        for index in offsets {
            context.delete(reminders[index])
        }
    }
}


#Preview {
    ReminderListView(filter: .filterAllReminder)
}
