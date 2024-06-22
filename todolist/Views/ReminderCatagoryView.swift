//
//  ReminderCatagoryView.swift
//  todolist
//
//  Created by David Zhu on 2024-06-19.
//

import SwiftUI

struct ReminderCatagoryView: View {
    var reminderCount = 0
    var catagoryName = "All"
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Image(systemName: catagoryName == "All" ? "tray.full.fill" : "calendar.badge.clock")
                    .imageScale(.large)
                    .foregroundStyle(catagoryName == "All" ? Color.blue : Color.red)
                Text(catagoryName)
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
    ReminderCatagoryView()
}
