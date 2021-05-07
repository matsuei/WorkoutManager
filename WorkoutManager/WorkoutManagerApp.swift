//
//  WorkoutManagerApp.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/04/04.
//

import SwiftUI

@main
struct WorkoutManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MenusListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
