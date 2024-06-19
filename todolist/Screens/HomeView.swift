//
//  ContentView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var isAddReminderDialogPresented = false
    var reminders: [Reminder] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List(reminders) { reminder in
                    NavigationLink(destination: ReminderFormView(reminder: reminder)) {
                        ReminderCellView(reminder: reminder)
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

