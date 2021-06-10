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
                    Image(systemName: "1.square.fill")
                    Text("menu")
                }
            AnalyticsView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("calender")
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
