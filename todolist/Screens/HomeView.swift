//
//  ContentView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var context
    @State private var isAddReminderDialogPresented = false
    
    // Computed properties can't be used in a query,
    // https://stackoverflow.com/a/77218372/16317008
    @Query(
        filter: #Predicate<Reminder> { $0.completeDate != nil },
        sort: [SortDescriptor(\Reminder.completeDate, order: .forward)]
    )
    var completedReminders: [Reminder]
    @Query(
        filter: #Predicate<Reminder> { $0.completeDate == nil && $0.dueDate != nil },
        sort: [SortDescriptor(\Reminder.dueDate, order: .forward)])
    var scheduledReminders: [Reminder]
    @Query(
        filter: #Predicate<Reminder> { $0.completeDate == nil && $0.dueDate == nil },
        sort: [SortDescriptor(\Reminder.createDate, order: .forward)])
    var unScheduledReminders: [Reminder]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(scheduledReminders) { reminder in
                        NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
                            ReminderCellView(reminder: reminder)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(scheduledReminders[index])
                        }
                    }
                }
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
            .navigationTitle("Todo List")
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isAddReminderDialogPresented) {
                AddReminderView()
            }
            .overlay {
                if scheduledReminders.isEmpty {
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

