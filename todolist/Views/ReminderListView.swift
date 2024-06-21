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
    @Query var reminderList: [Reminder]
    var title: String
    
    init(title: String = "Untitled", filter: ReminderPredicate) {
        self.title = title
        self._reminderList = Query(filter: Reminder.predicateFor(filter).0, sort: Reminder.predicateFor(filter).1)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(reminderList) { reminder in
                    NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
                        ReminderCellView(reminder: reminder)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(reminderList[index])
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


#Preview {
    ReminderListView(filter: .filterAllReminder)
}
