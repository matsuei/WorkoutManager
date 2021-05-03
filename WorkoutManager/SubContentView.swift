//
//  SubContentView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/06.
//

import SwiftUI

struct SubContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<Record>
    private var items: FetchedResults<Record> { fetchRequest.wrappedValue }
    
    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    Text(String(item.weight))
                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
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

struct SubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentView(fetchRequest: FetchRequest<Record>(entity: Record.entity(), sortDescriptors: [], predicate: NSPredicate(format: "menuID == %@", ""))).environment(\.managedObjectContext, PersistenceController.addMenuPreview.container.viewContext)
    }
}
