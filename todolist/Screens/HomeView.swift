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
    @State private var searchText = ""
    @State private var refreshID = UUID()

    @Query private var scheduledReminders: [Reminder]
    @Query private var unfinishedReminders: [Reminder]
    @Query private var allReminders: [Reminder]
    
    init() {
        let (scheduledFilter, scheduledSort) = Reminder.predicateFor(.filterScheduledReminder)
        let (unfinishedFilter, unfinishedSort) = Reminder.predicateFor(.filterUnfinishedReminder)
        
        _scheduledReminders = Query(filter: scheduledFilter, sort: scheduledSort)
        _unfinishedReminders = Query(filter: unfinishedFilter, sort: unfinishedSort)
        _allReminders = Query()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                reminderCategoryLinks
                reminderList
            }
            .background(Color(UIColor.systemGray6))
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isAddReminderDialogPresented) {
                AddReminderView()
            }
            .overlay {
                if unfinishedReminders.isEmpty && searchText.isEmpty {
                    emptyStateView
                }
            }
        }
        .onReceive(willEnterForegroundNotification) { _ in
            updateUnfinishedReminderStatus()
        }
    }
    
    private var reminderCategoryLinks: some View {
        HStack(spacing: 20) {
            NavigationLink(destination: DummyView(title: "ALL", filter: .filterAllReminder)) {
                ReminderCategoryView(reminderCount: allReminders.count, categoryName: "All")
            }
            NavigationLink(destination: DummyView(title: "Scheduled", filter: .filterScheduledReminder)) {
                ReminderCategoryView(reminderCount: scheduledReminders.count, categoryName: "Scheduled")
            }
        }
        .padding()
    }
    
    private var reminderList: some View {
        List {
            ForEach(filteredReminders) { reminder in
                ReminderListRowView(reminder: reminder)
            }
            .onDelete(perform: deleteReminders)
        }
        .searchable(text: $searchText, prompt: Text("Search"))
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(PlainListStyle())
        .overlay(alignment: .bottomLeading) {
            addReminderButton
        }
    }
    
    private var addReminderButton: some View {
        Button {
            isAddReminderDialogPresented = true
        } label: {
            Label("New Reminder", systemImage: "plus")
                .fontWeight(.bold)
                .padding()
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            label: { Label("No Reminders", systemImage: "list.number") },
            description: { Text("You have done all the tasks!!") }
        )
    }
    
    private func containsSearchTerm(_ reminder: Reminder) -> Bool {
        reminder.title.localizedCaseInsensitiveContains(searchText) ||
        reminder.notes.localizedCaseInsensitiveContains(searchText)
    }
    
    private var filteredReminders: [Reminder] {
        searchText.isEmpty ? unfinishedReminders : allReminders.filter(containsSearchTerm)
    }
    
    private var willEnterForegroundNotification: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    }
    
    private func deleteReminders(at offsets: IndexSet) {
        for index in offsets {
            let reminder = filteredReminders[index]
            NotificationManager.removeNotification(for: reminder)
            context.delete(reminder)
        }
    }
    
    private func updateUnfinishedReminderStatus() {
        let currentDate = Date()
        for index in filteredReminders.indices {
            if let dueDate = filteredReminders[index].dueDate {
                filteredReminders[index].isOverdue = filteredReminders[index].completedAt == nil && dueDate < currentDate
            } else {
                filteredReminders[index].isOverdue = false
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

