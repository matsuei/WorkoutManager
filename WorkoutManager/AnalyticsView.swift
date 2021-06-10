//
//  AnalyticsView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/10.
//

import SwiftUI

struct AnalyticsView: View {
    @State private var selectionDate = Date()
    
    var body: some View {
        VStack {
            HStack {
                Text(selectionDate, style: .date)
                DatePicker("タイトル", selection: $selectionDate, displayedComponents: .date)
                    .labelsHidden()
            }
            HStack {
                Text(selectionDate, style: .date)
                DatePicker("タイトル", selection: $selectionDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
