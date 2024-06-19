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
    @State var isAddReminderDialogPresented = false
    @Query var reminders: [Reminder]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(reminders) { reminder in
                        NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
                            ReminderCellView(reminder: reminder)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(reminders[index])
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
                if reminders.isEmpty {
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

