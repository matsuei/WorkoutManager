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
        sortDescriptors: [NSSortDescriptor(keyPath: \Menu.part, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Menu>
    private var chestMenus: [Menu] {
        items.filter({$0.part! == Part.chest.rawValue})
    }
    private var backMenus: [Menu] {
        items.filter({$0.part! == Part.back.rawValue})
    }
    private var shoulderMenus: [Menu] {
        items.filter({$0.part! == Part.shoulder.rawValue})
    }
    private var bicepsMenus: [Menu] {
        items.filter({$0.part! == Part.biceps.rawValue})
    }
    private var tricepsMenus: [Menu] {
        items.filter({$0.part! == Part.triceps.rawValue})
    }
    private var legMenus: [Menu] {
        items.filter({$0.part! == Part.leg.rawValue})
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Chest")) {
                    ForEach(chestMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Back")) {
                    ForEach(backMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Shoulder")) {
                    ForEach(shoulderMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Biceps")) {
                    ForEach(bicepsMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Triceps")) {
                    ForEach(tricepsMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Leg")) {
                    ForEach(legMenus) { item in
                        HStack {
                            Text(item.title!)
                            NavigationLink(destination: SubContentView(menuID: item.id!)) {
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .listStyle(InsetGroupedListStyle())
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
                    }
                }
            }
            .sheet(isPresented: $showingModal) {
                AddMenuView()
                    .environment(\.managedObjectContext, viewContext)
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
