//
//  MainTabView.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/06/08.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            MenusListView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Menu List")
                }
            AnalyticsView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Date Search")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.managedObjectContext, PersistenceController.menuListPreview.container.viewContext)
    }
}
