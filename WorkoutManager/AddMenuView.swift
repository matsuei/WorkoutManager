//
//  AddMenuView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/11.
//

import SwiftUI

struct AddMenuView: View {
    @State private var title: String = ""
    @State private var part: String = ""
    
    var body: some View {
        VStack {
            TextField(
                "Title",
                text: $title)
                .disableAutocorrection(true)
            TextField(
                "Part",
                text: $part)
                .disableAutocorrection(true)
            }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView()
    }
}
