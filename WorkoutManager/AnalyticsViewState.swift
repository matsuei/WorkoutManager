//
//  AnalyticsViewState.swift
//  WorkoutManager
//
//  Created by Kenta Matsue on 2022/10/08.
//

import Foundation
import CoreData

class AnalyticsViewState: ObservableObject {
    struct SectionItem: Identifiable {
        var id = UUID()
        var menu: String
        var records: [Record]
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
    @Published var sectionItems: [SectionItem] = []
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    func search() {
        sectionItems = []
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
                sectionItems.append(SectionItem(menu: menu.title!, records: records))
            }
        } catch {
            print("Fetch error:", error)
        }
    }
    
    func dateString(from date: Date) -> String {
        return itemFormatter.string(from: date)
    }
}
