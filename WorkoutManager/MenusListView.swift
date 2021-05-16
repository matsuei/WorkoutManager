//
//  MenusListView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/04.
//

import SwiftUI
import CoreData

struct MenusListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingModal = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Menu.part, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Menu>
    private struct ListItem: Identifiable {
        var id = UUID()
        var section: Int
        var part: Part
        var menus: [Menu]
    }
    private var listItems: [ListItem] {
        var itemss = [ListItem]()
        Part.allCases.enumerated().forEach { index, part in
            itemss.append(ListItem(section: index, part: part, menus: items.filter({$0.part! == part.rawValue})))
        }
        return itemss
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(listItems) { item in
                    Section(header: Text(item.part.text)) {
                        ForEach(item.menus) { menu in
                            HStack {
                                Text(menu.title!)
                                NavigationLink(destination: RecordsListView(menuContent: MenuContent(id: menu.id!, part: Part(rawValue: menu.part!)!, title: menu.title!, memo: menu.memo ?? ""))) {
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            deleteItems(offsets: indexSet, section: item.section)
                        })
                    }
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

    private func deleteItems(offsets: IndexSet, section: Int) {
        withAnimation {
            offsets.map { listItems[section].menus[$0] }.forEach(viewContext.delete)
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

struct MenusListView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en", "ja"], id: \.self) { id in
            MenusListView()
                .environment(\.managedObjectContext, PersistenceController.menuListPreview.container.viewContext)
                .environment(\.locale, .init(identifier: id)) 
        }
    }
}
