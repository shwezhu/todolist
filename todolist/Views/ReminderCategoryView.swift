//
//  ReminderCatagoryView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-19.
//

import SwiftUI

struct ReminderCategoryView: View {
    var reminderCount = 0
    var categoryName = "All"
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Image(systemName: categoryName == "All" ? "tray.full.fill" : "calendar.badge.clock")
                    .imageScale(.large)
                    .foregroundStyle(categoryName == "All" ? Color.blue : Color.red)
                Text(categoryName)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Text("\(reminderCount)")
                .font(.title)
                .bold()
                .foregroundStyle(Color.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    ReminderCategoryView()
}
