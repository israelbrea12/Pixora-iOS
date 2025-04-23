//
//  MainView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabBarVisibility = TabBarVisibilityManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                HomeView()
                    .tabItem { Image(systemName: "house") }

                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }

                AddMyPhotoView()
                    .tabItem { Image(systemName: "plus") }
                
                NotificationsView()
                    .tabItem { Image(systemName: "bell") }

                ProfileView()
                    .tabItem { Image(systemName: "person") }
            }
            .environmentObject(tabBarVisibility)
            .padding(.bottom, tabBarVisibility.isVisible ? 0 : -200)
            .animation(
                .easeInOut(duration: 0.5),
                value: tabBarVisibility.isVisible
            )
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            NotificationManager.shared.requestAuthorization()
        }
        .onChange(of: scenePhase) {
            handleScenePhaseChange()
        }
    }
    
    private func handleScenePhaseChange() {
        switch scenePhase {
        case .background:
            NotificationManager.shared.scheduleNotification(
                title: "Pixora",
                body: "Explora y comparte fotos con la comunidad ¡Qué divertido!",
                inSeconds: 5
            )

            NotificationManager.shared.scheduleNotification(
                title: "Pixora",
                body: "Pixora te echa de menos 😢 ¡Vuelve y mira las nuevas fotos increíbles!",
                inSeconds: 30
            )

        case .active:
            NotificationManager.shared.cancelAllNotifications()

        default:
            break
        }
    }
}


#Preview {
    MainView()
}
