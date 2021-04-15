//
//  ContentView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingModal = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Menu.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Menu>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        Text(item.title!)
                        NavigationLink(destination: SubContentView(part: item.part!)) {
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        self.showingModal.toggle()
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }.sheet(isPresented: $showingModal) {
                        AddMenuView()
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Menu(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = "test"
            newItem.part = "chest"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
