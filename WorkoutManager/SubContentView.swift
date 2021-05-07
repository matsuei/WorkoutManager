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
        items.filter({$0.menuID == menu.id!}).sorted(by: { $0.timestamp!.compare($1.timestamp!) == .orderedDescending})
    }
    private struct ListItem: Identifiable {
        var id = UUID()
        var dateString: String
        var records: [Record]
    }
    private var listItems: [ListItem] {
        var items = [ListItem]()
        guard let date = filteredItems.first?.timestamp else {
            return items
        }
        var dateString = itemFormatter.string(from: date)
        var records: [Record] = []
        filteredItems.forEach { record in
            if dateString == itemFormatter.string(from: record.timestamp!) {
                records.append(record)
            } else {
                items.append(ListItem(dateString: dateString, records: records))
                dateString = itemFormatter.string(from: record.timestamp!)
                records = [record]
            }
        }
        if items.isEmpty {
            items.append(ListItem(dateString: dateString, records: records))
        }
        return items
    }
    @State private var showingModal = false
    @State private var memo: String = ""
    let menu: Menu
    
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
                    memo = menu.memo!
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
                    .onDelete(perform: deleteItems)
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
            AddRecordView(menuID: menu.id!)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func addItem() {
        menu.memo = memo
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
        SubContentView(menu: Menu()).environment(\.managedObjectContext, PersistenceController.addMenuPreview.container.viewContext)
    }
}
