//
//  ContentView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI

struct HomeView: View {
    @State var isAddReminderDialogPresented = false
    @State var reminders = mockData()
    
    var body: some View {
        VStack {
            List(reminders) { reminder in
                ReminderCellView(reminder: reminder)
            }
            Button {
                isAddReminderDialogPresented = true
            } label: {
                Label("New Reminder", systemImage: "plus.square")
            }
        }
        .sheet(isPresented: $isAddReminderDialogPresented) {
            AddReminderView()
        }
        
        
    }
}

func mockData() -> [Reminder] {
    let reminder1 = Reminder()
    reminder1.title = "Buy groceries"
    reminder1.description = "Get milk, eggs, and bread from the supermarket"
    reminder1.dueDate = Date().addingTimeInterval(3600) // Due in 1 hour
    reminder1.repeatingDays = [.monday, .wednesday, .friday]
    reminder1.isCompleted = false

    let reminder2 = Reminder()
    reminder2.title = "Dentist appointment"
    reminder2.dueDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())! // Due in 7 days
    reminder2.repeatingDays = []
    reminder2.isCompleted = false

    let reminder3 = Reminder()
    reminder3.title = "Submit project report"
    reminder3.description = "Finish and submit the quarterly project report"
    reminder3.dueDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())! // Due in 2 days
    reminder3.repeatingDays = [.tuesday, .thursday]
    reminder3.isCompleted = true

    let reminder4 = Reminder()
    reminder4.title = "Gym workout"
    reminder4.description = "Cardio and strength training session"
    reminder4.dueDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())! // Due in 2 hours
    reminder4.repeatingDays = [.monday, .wednesday, .friday]
    reminder4.isCompleted = false

    let reminder5 = Reminder()
    reminder5.title = "Call Mom"
    reminder5.description = "Weekly phone call with Mom"
    reminder5.dueDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())! // Due in 3 days
    reminder5.repeatingDays = [.sunday]
    reminder5.isCompleted = false
    
    return [reminder1, reminder2, reminder3, reminder4, reminder5]
}

#Preview {
    HomeView()
}

