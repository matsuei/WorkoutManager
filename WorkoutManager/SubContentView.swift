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
        List {
            Section {
                ForEach(filteredItems) { item in
                    HStack {
                        Text("At: \(item.timestamp!, formatter: itemFormatter)")
                        Text("Weight: \(String(item.weight))")
                        Text("Reps: \(String(item.reps))")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            Section {
                Button(action: {
                    showingModal.toggle()
                }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationBarTitle("record",
                            displayMode: .inline)
        .sheet(isPresented: $showingModal) {
            AddRecordView(menuID: menuID)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredItems[$0] }.forEach(viewContext.delete)

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
    formatter.timeStyle = .none
    return formatter
}()

struct SubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentView(menuID: "").environment(\.managedObjectContext, PersistenceController.addMenuPreview.container.viewContext)
    }
}
