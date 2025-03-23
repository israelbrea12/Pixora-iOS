//
//  MainView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                }
            FavsView()
                .tabItem {
                    Image(systemName: "star")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    MainView()
}
