//
//  AddReminderView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI
import SwiftData

struct AddReminderView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @State private var reminder = Reminder()

    private func commit() {
        context.insert(reminder)
        NotificationManager.scheduleNotification(for: reminder)
        dismiss() // dismiss the sheet
    }
    
    private func cancel() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ReminderFormView(reminder: reminder)
            // 必须在 NavigationStack 里面, 否则按钮不会显示
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                  Button(action: cancel) {
                    Text("Cancel")
                  }
                }
                ToolbarItem(placement: .confirmationAction) {
                  Button(action: commit) {
                    Text("Add")
                  }
                  .disabled(reminder.title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Reminder.self, configurations: config)

    return AddReminderView()
        .modelContainer(container)
}

