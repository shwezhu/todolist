//
//  MultiWeekdayPicker.swift
//  todolist
//
//  Created by David Zhu on 2024-06-14.
//

import SwiftUI

struct MultiWeekdayPicker: View {
    @Binding var selectedDays: Set<Weekday>
    @State var isNeverSelected = true
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    if !isNeverSelected {
                        isNeverSelected.toggle()
                        selectedDays.removeAll()
                    }
                } label: {
                    HStack {
                        Text("Never")
                            .foregroundStyle(Color.black)
                        Spacer()
                        if isNeverSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                ForEach(Weekday.allCases) { day in
                    Button{
                        isNeverSelected = false
                        if selectedDays.contains(day) && selectedDays.count != 1 {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }label: {
                        HStack {
                            Text(day.name.capitalized)
                                .foregroundStyle(Color.black)
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Repeat")
            .onAppear {
                if isNeverSelected {
                    isNeverSelected = selectedDays.isEmpty
                }
            }
        }
    }
}

#Preview {
    MultiWeekdayPicker(selectedDays: .constant([Weekday.friday]))
}
