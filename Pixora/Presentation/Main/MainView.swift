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
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var isPresented = false
    @State private var selectedImageForForm: IdentifiableImage? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem { Image(systemName: "house") }
                    .tag(0)

                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .tag(1)

                Color.clear // Placeholder view
                    .tabItem {
                        Image(systemName: "plus")
                    }
                    .tag(2)

                NotificationsView()
                    .tabItem { Image(systemName: "bell") }
                    .tag(3)

                ProfileView()
                    .tabItem { Image(systemName: "person") }
                    .tag(4)
            }
            .onChange(of: selectedTab) { newValue in
                if newValue == 2 {
                    selectedTab = previousTab
                    isPresented = true
                } else {
                    previousTab = newValue
                }
            }

            .sheet(isPresented: $isPresented) {
                BottomSheetView { image in
                    selectedImageForForm = IdentifiableImage(image: image)
                }
                .presentationDetents([.fraction(0.4), .medium])
                .presentationDragIndicator(.visible)
            }

            .sheet(item: $selectedImageForForm) { identifiable in
                NavigationStack {
                    PhotoFormView(image: identifiable.image)
                }
                .presentationDragIndicator(.visible)
            }

            .environmentObject(tabBarVisibility)
            .padding(.bottom, tabBarVisibility.isVisible ? 0 : -200)
            .animation(.easeInOut(duration: 0.5), value: tabBarVisibility.isVisible)
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            NotificationManager.shared.requestAuthorization()
        }
        .onChange(of: scenePhase) { _ in
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
