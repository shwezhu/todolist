//
//  AddReminderView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI

struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var reminderDate: Date = .now
    @State private var showCalendar = false
    
    private func commit() {
        
    }
    
    private func cancel() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...4)
                }
                Section {
                    Toggle(isOn: $showCalendar) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                    }
                    .tint(.black)
                    if showCalendar {
                        DatePicker("Due Date",
                                   selection: $reminderDate,
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
                NavigationLink(destination: Text("hello")) {
                    HStack {
                        Image(systemName: "repeat")
                        Text("Repeat")
                        Spacer()
                        Text("Never")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
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
                  .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddReminderView()
}

