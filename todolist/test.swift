import SwiftUI
import Observation

@Observable
class Item: Identifiable {
    let id = UUID()
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}

struct DetailView: View {
    let randomNumber = Int.random(in: 1...100)
    var body: some View {
        Text("Random Number: \(randomNumber)")
    }
}

struct ContentView: View {
    @State private var value = 99
    
    var body: some View {
        Text("Number: \(value)")
        DetailView()
        Button("+") { value += 1 }
    }
}

#Preview {
    ContentView()
}
