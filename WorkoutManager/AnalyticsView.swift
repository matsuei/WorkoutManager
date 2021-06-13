//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI

struct AnalyticsView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var part: Part = .chest
    
    var body: some View {
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
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
