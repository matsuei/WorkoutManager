//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var part: Part = .chest
    @State private var records: [Record] = []
    
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
                ForEach(records) { record in
                    Text("Weight: \(String(record.weight))")
                    Text("Reps: \(String(record.reps))")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
                        let predicate = NSPredicate(format: "timestamp BETWEEN {%@ , %@}", startDate as NSDate, endDate as NSDate)
                        fetchRequest.predicate = predicate
                        do {
                            records = try viewContext.fetch(fetchRequest)
                        } catch {
                            print("Fetch error:", error)
                        }
                    }) {
                        Label("Add Item", systemImage: "plus")
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
