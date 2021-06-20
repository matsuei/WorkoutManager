//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    private struct MenuRecord: Identifiable {
        var id = UUID()
        var menu: String
        var record: Record
    }
    private struct ListItem: Identifiable {
        var id = UUID()
        var section: Int
        var dateString: String
        var menuRecords: [MenuRecord]
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var part: Part = .chest
    @State private var menuRecords: [MenuRecord] = []
    
    private var listItems: [ListItem] {
        var items = [ListItem]()
        guard let date = menuRecords.first?.record.timestamp else {
            return items
        }
        var section = 0
        items.append(ListItem(section: section, dateString: itemFormatter.string(from: date), menuRecords: []))
        menuRecords.forEach { menuRecord in
            if items[section].dateString == itemFormatter.string(from: menuRecord.record.timestamp!) {
                items[section].menuRecords.append(menuRecord)
            } else {
                section = section + 1
                let dateString = itemFormatter.string(from: menuRecord.record.timestamp!)
                items.append(ListItem(section: section, dateString: dateString, menuRecords: [menuRecord]))
            }
        }
        return items
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("StartDate")
                        DatePicker("タイトル", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    HStack {
                        Text("EndDate")
                        DatePicker("タイトル", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                Section {
                    Picker(selection: $part, label: Text("chosePart")) {
                        ForEach(Part.allCases, id: \.self) { (part) in
                            Text(part.text)
                        }
                    }
                }
                ForEach(listItems) { item in
                    Section(header: Text(item.dateString)) {
                        ForEach(item.menuRecords) { menuRecord in
                            HStack {
                                Text(menuRecord.menu)
                                Text("Weight: \(String(menuRecord.record.weight))")
                                Text("Reps: \(String(menuRecord.record.reps))")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let menuFetchRequest = NSFetchRequest<Menu>(entityName: "Menu")
                        let predicate = NSPredicate(format: "part == %@", part.rawValue)
                        menuFetchRequest.predicate = predicate
                        do {
                            let menus = try viewContext.fetch(menuFetchRequest)
                            try menus.forEach { menu in
                                let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
                                let datePredicate = NSPredicate(format: "timestamp BETWEEN {%@ , %@}", startDate as NSDate, endDate as NSDate)
                                let menuPredicate = NSPredicate(format: "menuID == %@", menu.id!)
                                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, menuPredicate])
                                let records = try viewContext.fetch(fetchRequest)
                                records.forEach { record in
                                    menuRecords.append(MenuRecord( menu: menu.title!, record: record))
                                }
                            }
                        } catch {
                            print("Fetch error:", error)
                        }
                    }) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
