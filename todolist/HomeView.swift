//
//  ContentView.swift
//  Todo List
//
//  Created by David Zhu on 2024-06-13.
//

import SwiftUI

struct HomeView: View {
    @State var isAddReminderDialogPresented = false
    
    var body: some View {
        VStack {
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

#Preview {
    HomeView()
}

