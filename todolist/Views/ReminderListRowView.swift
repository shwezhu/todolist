//
//  ReminderListRowView.swift
//  todolist
//
//  Created by David Zhu on 2024-07-01.
//

import SwiftUI

struct ReminderListRowView: View {
    @Environment(\.modelContext) private var context
    @Namespace private var animation
    let reminder: Reminder

    var body: some View {
        ZStack {
            ReminderCellView(reminder: reminder, namespace: animation) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    toggleReminderState(for: reminder, action: .completion, in: context)
                }
            } onDropped: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    toggleReminderState(for: reminder, action: .drop, in: context)
                }
            }
            NavigationLink(destination: UpdateReminderView(reminder: reminder)) {}
                .opacity(0)
        }
    }
}
