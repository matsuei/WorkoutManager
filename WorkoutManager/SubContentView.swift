//
//  SubContentView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/06.
//

import SwiftUI

struct SubContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Record>
    private var filteredItems: [Record] {
        items.filter({$0.menuID == menuID})
    }
    @State private var showingModal = false
    let menuID: String
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems) { item in
                    HStack {
                        Text(String(item.weight))
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle("record",
                            displayMode: .inline)
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
            AddRecordView(menuID: menuID)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct SubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentView(menuID: "").environment(\.managedObjectContext, PersistenceController.addMenuPreview.container.viewContext)
    }
}
