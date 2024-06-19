//
//  MultiWeekdayPicker.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import SwiftUI

struct MultiWeekdayPicker: View {
    @Binding var selectedDays: Set<Weekday>
    
    var body: some View {
        NavigationStack {
            List {
                ListItem(title: "Never", isSelected: selectedDays.isEmpty) {
                    selectedDays.removeAll()
                }
                
                ForEach(Weekday.allCases, id: \.self) { day in
                    ListItem(title: day.name.capitalized, isSelected: selectedDays.contains(day)) {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
                }
            }
            .navigationTitle("Repeat")
        }
    }
}

struct ListItem: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(Color.black)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
}

#Preview {
    MultiWeekdayPicker(selectedDays: .constant([Weekday.friday]))
}
