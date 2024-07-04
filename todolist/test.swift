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

@Observable
class ItemList {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

struct ContentView: View {
    init(itemList: ItemList = ItemList(items: [
        Item(name: "Apple", count: 1),
        Item(name: "Banana", count: 2),
        Item(name: "Cherry", count: 3)
    ])) {
        self.itemList = itemList
    }
    
    @State private var itemList = ItemList(items: [
        Item(name: "Apple", count: 1),
        Item(name: "Banana", count: 2),
        Item(name: "Cherry", count: 3)
    ])
    
    var body: some View {
        VStack {
            List(itemList.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("Count: \(item.count)")
                    Button("Increment") {
                        item.count += 1
                        print("Incremented \(item.name) to \(item.count)")
                    }
                }
            }
            
            Button("Add New Item") {
                itemList.items.append(Item(name: "New Item", count: 1))
                print("Added new item")
            }
        }
    }
}

#Preview {
    ContentView()
}
