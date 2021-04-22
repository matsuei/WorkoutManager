//
//  PartSelectView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/15.
//

import SwiftUI

enum Part: String, CaseIterable {
    case chest
    case back
    case arm
    case leg
}

struct PartSelectView: View {
    var body: some View {
        List(Part.allCases, id: \.self) { part in
            HStack {
                Text(part.rawValue)
                Spacer()
                if part == .chest {
                    Image(systemName: "checkmark")
                }
              }
        }
    }
}

struct PartSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PartSelectView()
    }
}
