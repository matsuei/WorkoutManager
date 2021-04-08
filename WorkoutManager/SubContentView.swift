//
//  SubContentView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/06.
//

import SwiftUI

struct SubContentView: View {
    let part: String
    
    var body: some View {
        Text(part)
    }
}

struct SubContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentView(part: "chest")
    }
}
