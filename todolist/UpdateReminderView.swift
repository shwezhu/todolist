//
//  UpdateReminderView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-17.
//

import SwiftUI

struct UpdateReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var reminder: Reminder
    
    private func commit() {
        
    }
    
    private func cancel() {
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
    UpdateReminderView(reminder: Reminder())
}
