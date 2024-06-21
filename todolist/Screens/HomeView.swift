//
//  ContentView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // @Environment(\.modelContext) var context
    @State private var isAddReminderDialogPresented = false
    // @State private var filter = ""
    // Computed properties can't be used in a query,
    // https://stackoverflow.com/a/77218372/16317008
    @Query(filter: Reminder.predicateFor(.filterScheduledReminder).0,
           sort: Reminder.predicateFor(.filterScheduledReminder).1)
    var scheduledReminders: [Reminder]
    @Query(filter: Reminder.predicateFor(.filterUnfinishedReminder).0,
           sort: Reminder.predicateFor(.filterUnfinishedReminder).1)
    var unFinishedReminders: [Reminder]
    @Query var allReminders: [Reminder]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 20) {
                    NavigationLink (destination: DummyView(filter: .filterAllReminder)) {
                        ReminderCatagoryView(reminderCount: allReminders.count, catagoryName: "All")
                    }
                    NavigationLink (destination: DummyView(filter: .filterScheduledReminder)) {
                        ReminderCatagoryView(reminderCount: scheduledReminders.count, catagoryName: "Scheduled")
                    }
                }
                .padding()
                Spacer()
//                List {
//                    ForEach(allReminders) { reminder in
//                        NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
//                            ReminderCellView(reminder: reminder)
//                        }
//                    }
//                    .onDelete { indexSet in
//                        for index in indexSet {
//                            context.delete(allReminders[index])
//                        }
//                    }
//                }
//                .searchable(text: $filter, prompt: Text("Filter reminders on title"))
                HStack {
                    Button {
                        isAddReminderDialogPresented = true
                    } label: {
                        Label("New Reminder", systemImage: "plus")
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding(.leading)
            }
            .background(Color(UIColor.systemGray6))
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isAddReminderDialogPresented) {
                AddReminderView()
            }
            .overlay {
                if true {
                    ContentUnavailableView(
                        label: {Label("No Reminders", systemImage: "list.number")},
                        description: {Text("Add some reminders first to see your reminder list.")}
                    )
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)

    return HomeView()
        .modelContainer(container)
}

