//
//  test.swift
//  todolist
//
//  Created by David Zhu on 2024-06-17.
//

import SwiftUI

struct ParentView: View {
    @State var counter: Int = 0

    var body: some View {
        VStack {
            Text("ContentView \(counter)")
            SecondView()
            ThirdView()
            Button {
                counter += 1
            } label: {
                Text("Go!")
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("SecondView")
            .background(.debug)
    }
}

struct ThirdView: View {
  let randomNumber = Int.random(in: 1...100)
  var body: some View {
    Text("Random Number: \(randomNumber)")
  }
}

public extension ShapeStyle where Self == Color {
    static var debug: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

#Preview {
    ParentView()
}
