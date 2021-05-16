//
//  RecordsListView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/06.
//

import SwiftUI

struct MenuContent {
    var id: String
    var part: Part
    var title: String
    var memo: String
}

struct RecordsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var records: FetchedResults<Record>
    private struct ListItem: Identifiable {
        var id = UUID()
        var section: Int
        var dateString: String
        var records: [Record]
    }
    private var listItems: [ListItem] {
        var items = [ListItem]()
        guard let date = records.first?.timestamp else {
            return items
        }
        var section = 0
        items.append(ListItem(section: section, dateString: itemFormatter.string(from: date), records: []))
        records.forEach { record in
            if items[section].dateString == itemFormatter.string(from: record.timestamp!) {
                items[section].records.append(record)
            } else {
                section = section + 1
                let dateString = itemFormatter.string(from: record.timestamp!)
                items.append(ListItem(section: section, dateString: dateString, records: [record]))
            }
        }
        return items
    }
    @State private var showingModal = false
    @State private var title: String
    @State private var part: Part
    @State private var memo: String
    @FetchRequest var menu: FetchedResults<Menu>
    
    init(menuContent: MenuContent) {
        _menu = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Menu.id, ascending: true)],
            predicate: NSPredicate(format: "id == %@", menuContent.id),
            animation: .default)
        _records = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Record.timestamp, ascending: false)],
            predicate: NSPredicate(format: "menuID == %@", menuContent.id),
            animation: .default)
        _title = State(initialValue: menuContent.title)
        _part = State(initialValue: menuContent.part)
        _memo = State(initialValue: menuContent.memo)
    }
    
    var body: some View {
        List {
            Section() {
                TextEditor(text: $title)
                    .onChange(of: title) { _ in
                        addItem()
                }
                Picker(selection: $part, label: Text("chosePart")) {
                    ForEach(Part.allCases, id: \.self) { (part) in
                        Text(part.text)
                    }
                }
                .onChange(of: part, perform: { value in
                    addItem()
                })
            }
            Section(header: Text("memo")) {
                ZStack(alignment: .leading) {
                    if memo.isEmpty {
                        Text("memo")
                            .foregroundColor(.secondary)
                    }
                    TextEditor(text: $memo)
                        .onChange(of: memo) { _ in
                            addItem()
                    }
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingModal.toggle()
                }) {
                    Label(NSLocalizedString("addRecord", comment: "Add Record"), systemImage: "plus")
                }
            }
        }
        .navigationBarTitle(title,
                            displayMode: .inline)
        .sheet(isPresented: $showingModal) {
            let weight: Float = records.last?.weight ?? 0
            let reps: Int64 = records.last?.reps ?? 0
            AddRecordView(menuID: menu.first?.id ?? "", previousRecord: (weight, reps))
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func addItem() {
        guard let menu = menu.first else {
            return
        }
        menu.title = title
        menu.part = part.rawValue
        menu.memo = memo
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItems(offsets: IndexSet, section: Int) {
        withAnimation {
            offsets.map { listItems[section].records[$0] }.forEach(viewContext.delete)
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
        let menuContent = MenuContent(id: "test", part: .chest, title: "title", memo: "")
        return RecordsListView(menuContent: menuContent).environment(\.managedObjectContext, PersistenceController.recordsListPreview.container.viewContext)
    }
}
