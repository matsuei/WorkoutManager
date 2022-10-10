//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    @ObservedObject private var state: AnalyticsViewState = .init()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("StartDate")
                        DatePicker("タイトル", selection: $state.startDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    HStack {
                        Text("EndDate")
                        DatePicker("タイトル", selection: $state.endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                Section {
                    Picker(selection: $state.part, label: Text("chosePart")) {
                        ForEach(Part.allCases, id: \.self) { (part) in
                            Text(part.text)
                        }
                    }
                }
                ForEach(state.listItems) { item in
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
                        state.search()
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
