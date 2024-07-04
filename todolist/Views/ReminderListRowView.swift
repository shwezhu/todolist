//
//  ReminderListRowView.swift
//  todolist
//
//  Created by David Zhu on 2024-07-01.
//

import SwiftUI
import Observation

struct ReminderListRowView: View {
    @Environment(\.modelContext) private var context
    @Namespace private var animation
    let reminder: Reminder
    
    var body: some View {
        ZStack {
            reminderContent
            NavigationLink(destination: UpdateReminderView(reminder: reminder)) {
                EmptyView()
            }
            .opacity(0)
        }
    }
    
    private var reminderContent: some View {
        HStack(alignment: .center) {
            completionIcon
            reminderDetails
            Spacer()
            dropIcon
        }
        .padding()
    }
    
    private var completionIcon: some View {
        Image(systemName: reminder.completedAt == nil ? "circle" : "largecircle.fill.circle")
            .imageScale(.large)
            .foregroundStyle(iconColor)
            .matchedGeometryEffect(id: "icon_\(reminder.id)", in: animation)
            .onTapGesture(perform: onToggle)
    }
    
    private var reminderDetails: some View {
        VStack(alignment: .leading) {
            Text(reminder.title)
                .foregroundStyle(titleColor)
                .strikethrough(reminder.isDropped)
                .matchedGeometryEffect(id: "title_\(reminder.id)", in: animation)
            
            if !reminder.notes.isEmpty {
                Text(reminder.notes)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .matchedGeometryEffect(id: "notes_\(reminder.id)", in: animation)
            }
            
            if let dueDate = reminder.dueDate {
                Text(formatDate(for: dueDate))
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .matchedGeometryEffect(id: "dueDate_\(reminder.id)", in: animation)
            }
        }
    }
    
    private var dropIcon: some View {
        Image(systemName: "flag.slash")
            .imageScale(.large)
            .foregroundStyle(reminder.completedAt == nil ? .orange : .gray)
            .onTapGesture(perform: onDrop)
    }
    
    private var iconColor: Color {
        reminder.isOverdue ? .red : (reminder.isDropped ? .gray : .blue)
    }
    
    private var titleColor: Color {
        reminder.isDropped ? .gray : (reminder.isOverdue ? .red : .primary)
    }
    
    private var secondaryTextColor: Color {
        reminder.isOverdue ? .red.opacity(0.6) : .gray
    }
    
    private func onToggle() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toggleReminderState(for: reminder, action: .completion, in: context)
        }
    }
    
    private func onDrop() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toggleReminderState(for: reminder, action: .drop, in: context)
        }
    }
    
    private func formatDate(for date: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        switch true {
        case calendar.isDateInToday(date):
            dateFormatter.dateFormat = "'Today,' h:mm a"
        case calendar.isDateInTomorrow(date):
            dateFormatter.dateFormat = "'Tomorrow,' h:mm a"
        default:
            dateFormatter.dateFormat = "yyyy-MM-dd, h:mm a"
        }
        
        return dateFormatter.string(from: date)
    }

    
}
