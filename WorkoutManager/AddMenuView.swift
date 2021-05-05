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
    case shoulder
    case biceps
    case triceps
    case leg
}

struct AddMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var title: String = ""
    @State private var part: Part = .chest
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Title", text: $title)
                        .disableAutocorrection(true)
                }
                Section {
                    Picker(selection: $part, label: Text("Chose Part")) {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("register") {
                        addItem()
                    }
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = Menu(context: viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.part = part.rawValue

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuView()
    }
}
