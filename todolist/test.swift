//
//  test.swift
//  todolist
//
//  Created by David Zhu on 2024-06-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Tap Me") {
                Text("Detail View")
            }
            .navigationTitle("SwiftUI")
        }
    }
}

#Preview {
    ContentView()
}
