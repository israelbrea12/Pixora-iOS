//
//  MainView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabBarVisibility = TabBarVisibilityManager()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                HomeView()
                    .tabItem { Image(systemName: "house") }

                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }

                NotificationsView()
                    .tabItem { Image(systemName: "bell") }

                FavsView()
                    .tabItem { Image(systemName: "star") }

                ProfileView()
                    .tabItem { Image(systemName: "person") }
            }
            .environmentObject(tabBarVisibility)
            .padding(.bottom, tabBarVisibility.isVisible ? 0 : -200)
            .animation(.easeInOut(duration: 0.5), value: tabBarVisibility.isVisible)
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
