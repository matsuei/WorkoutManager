//
//  AddMenuView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/11.
//

import SwiftUI

enum Part: String, CaseIterable {
    case chest
    case back
    case arm
    case leg
}

struct AddMenuView: View {
    @State private var title: String = ""
    @State private var part: String = ""
    @State private var selection: Part = .chest
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(
                        "Title",
                        text: $title)
                        .disableAutocorrection(true)
                    TextField(
                        "Part",
                        text: $part)
                        .disableAutocorrection(true)
                }
                Section {
                    Picker(selection: $selection, label: Text("Chose Part")) {
                        ForEach(Part.allCases, id: \.self) { (part) in
                            Text(part.rawValue)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView()
    }
}
