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
                    NavigationLink(
                        destination: PartSelectView(),
                        label: {
                            Text("Select Part")
                        })
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
