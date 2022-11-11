//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI
import CoreData
import Charts

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
                ForEach(state.sectionItems) { item in
                    Section(header: Text(item.menu)) {
                        Chart(item.records) { record in
                            PointMark(
                                x: .value("Date", record.timestamp!),
                                y: .value("Reps", record.reps)
                            )
                            .annotation(position: .overlay, alignment: .center) {
                                Text(String(record.weight))
                                    .font(.system(size: 10))
                            }
                            .symbolSize(0)
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 10)) { date in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.day().month())
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
