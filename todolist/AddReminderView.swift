//
//  AddReminderView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reminder = Reminder()
    @State private var showCalendar = false
    
    private func commit() {
        
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
    AddReminderView()
}

