//
//  RecordsListView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/06.
//

import SwiftUI

struct RecordsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var records: FetchedResults<Record>
    private struct ListItem: Identifiable {
        var id = UUID()
        var index: Int
        var dateString: String
        var records: [Record]
    }
    private var listItems: [ListItem] {
        var items = [ListItem]()
        guard let date = records.first?.timestamp else {
            return items
        }
        var dateString = itemFormatter.string(from: date)
        var itemRecords: [Record] = []
        var index = 0
        records.forEach { record in
            if dateString == itemFormatter.string(from: record.timestamp!) {
                itemRecords.append(record)
            } else {
                items.append(ListItem(index: index, dateString: dateString, records: itemRecords))
                index = index + 1
                dateString = itemFormatter.string(from: record.timestamp!)
                itemRecords = [record]
            }
        }
        items.append(ListItem(index: index, dateString: dateString, records: itemRecords))
        return items
    }
    @State private var showingModal = false
    @State private var memo: String = ""
    @FetchRequest var menu: FetchedResults<Menu>
    
    init(menuID: String) {
        _menu = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Menu.id, ascending: true)],
            predicate: NSPredicate(format: "id == %@", menuID),
            animation: .default)
        _records = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Record.timestamp, ascending: true)],
            predicate: NSPredicate(format: "menuID == %@", menuID),
            animation: .default)
    }
    
    var body: some View {
        List {
            Section(header: Text("Memo")) {
                ZStack(alignment: .leading) {
                    if memo.isEmpty {
                        Text(" Memo")
                            .foregroundColor(.secondary)
                    }
                    TextEditor(text: $memo)
                        .onChange(of: memo) { _ in
                            addItem()
                    }
                }
                .onAppear {
                    memo = menu.first?.memo ?? ""
                }
            }
            ForEach(listItems) { item in
                Section(header: Text(item.dateString)) {
                    ForEach(item.records) { record in
                        HStack {
                            Text("Weight: \(String(record.weight))")
                            Text("Reps: \(String(record.reps))")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        deleteItems(offsets: indexSet, index: item.index)
                    })
                }
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
            AddRecordView(menuID: menu.first?.id ?? "")
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func addItem() {
        guard let menu = menu.first else {
            return
        }
        menu.memo = memo
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItems(offsets: IndexSet, index: Int) {
        withAnimation {
            offsets.map { listItems[index].records[$0] }.forEach(viewContext.delete)
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

struct RecordsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsListView(menuID: "test").environment(\.managedObjectContext, PersistenceController.recordsListPreview.container.viewContext)
    }
}
