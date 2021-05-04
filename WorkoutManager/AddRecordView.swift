//
//  AddRecordView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/05/04.
//

import SwiftUI

struct AddRecordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var weight: String = ""
    @State private var reps: String = ""
    @Environment(\.presentationMode) private var presentationMode
    let menuID: String
    
    var body: some View {
        NavigationView {
            List {
                TextField("Weight", text: $weight)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                TextField("Reps", text: $reps)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
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
        guard let weight = Float(weight), let reps = Int64(reps) else {
            return
        }
        let newItem = Record(context: viewContext)
        newItem.menuID = menuID
        newItem.weight = weight
        newItem.timestamp = Date()
        newItem.reps = Int64(reps)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(menuID: "")
    }
}
