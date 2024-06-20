//
//  ReminderListView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-20.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    @Environment(\.modelContext) var context
    @Query private var reminderList: [Reminder]
    var listTitle: String
    
    init(title: String, filter: ReminderPredicate) {
        self.listTitle = title
        var sortDescriptors: [SortDescriptor<Reminder>]
        var filterPredicate: Predicate<Reminder>?
        
        switch filter {
        case .filterAllReminder:
            filterPredicate = nil
            sortDescriptors = [
                SortDescriptor(\Reminder.completeDate, order: .forward),
                SortDescriptor(\Reminder.dueDate, order: .forward)
            ]
        case .filterScheduledReminder:
            filterPredicate = #Predicate { $0.dueDate != nil && $0.completeDate == nil }
            sortDescriptors = [SortDescriptor(\Reminder.dueDate, order: .forward)]
        case .filterUnscheduledReminder:
            filterPredicate = #Predicate { $0.dueDate == nil && $0.completeDate == nil }
            sortDescriptors = [SortDescriptor(\Reminder.createDate, order: .forward)]
        case .filterFinishedReminder:
            filterPredicate = #Predicate { $0.completeDate != nil }
            sortDescriptors = [SortDescriptor(\Reminder.completeDate, order: .forward)]
        case .filterUnfinishedReminder:
            filterPredicate = #Predicate { $0.completeDate == nil }
            sortDescriptors = [SortDescriptor(\Reminder.dueDate, order: .forward)]
        }
        
        self._reminderList = Query(filter: filterPredicate, sort: sortDescriptors)
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
            .navigationTitle(listTitle)
        }
    }
}


#Preview {
    ReminderListView(title: "Scheduled", filter: .filterAllReminder)
}
