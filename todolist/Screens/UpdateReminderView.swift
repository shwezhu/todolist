//
//  UpdateReminderView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-17.
//

import SwiftUI
import SwiftData

struct UpdateReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var reminder: Reminder // @Bindable Modifications will be saved to SwiftData.
    
    private func commit() {
        NotificationManager.updateNotification(for: reminder)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            ReminderFormView(reminder: reminder)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                  Button(action: commit) {
                    Text("Done")
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
    let reminder = Reminder()
    
    return UpdateReminderView(reminder: reminder)
        .modelContainer(container)
}
