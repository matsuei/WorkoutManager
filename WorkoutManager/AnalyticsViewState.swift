//
//  AnalyticsViewState.swift
//  WorkoutManager
//
//  Created by Kenta Matsue on 2022/10/08.
//

import Foundation
import CoreData

class AnalyticsViewState: ObservableObject {
    struct MenuRecord: Identifiable {
        var id = UUID()
        var menu: String
        var record: Record
    }
    struct ListItem: Identifiable {
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
    
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var part: Part = .chest
    @Published var menuRecords: [MenuRecord] = []
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    var listItems: [ListItem] {
        var items = [ListItem]()
        guard let date = menuRecords.first?.record.timestamp else {
            return items
        }
        var section = 0
        items.append(ListItem(section: section, dateString: itemFormatter.string(from: date), menuRecords: []))
        menuRecords.forEach { menuRecord in
            if let index = items.firstIndex(where: {$0.dateString == itemFormatter.string(from: menuRecord.record.timestamp!)}) {
                items[index].menuRecords.append(menuRecord)
            } else {
                section = section + 1
                let dateString = itemFormatter.string(from: menuRecord.record.timestamp!)
                items.append(ListItem(section: section, dateString: dateString, menuRecords: [menuRecord]))
            }
        }
        items.sort { left, right in
            return left.dateString > right.dateString
        }
        return items
    }
    
    func search() {
        menuRecords = []
        let menuFetchRequest = NSFetchRequest<Menu>(entityName: "Menu")
        let predicate = NSPredicate(format: "part == %@", part.rawValue)
        menuFetchRequest.predicate = predicate
        do {
            let menus = try persistenceController.container.viewContext.fetch(menuFetchRequest)
            try menus.forEach { menu in
                let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
                let datePredicate = NSPredicate(format: "timestamp BETWEEN {%@ , %@}", startDate as NSDate, endDate as NSDate)
                let menuPredicate = NSPredicate(format: "menuID == %@", menu.id!)
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, menuPredicate])
                let records = try persistenceController.container.viewContext.fetch(fetchRequest)
                records.forEach { record in
                    menuRecords.append(MenuRecord( menu: menu.title!, record: record))
                }
            }
        } catch {
            print("Fetch error:", error)
        }
    }
}
