//
//  MainView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import UIKit
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = Resolver.shared.resolve(MainViewModel.self)
    @StateObject private var tabBarVisibility = TabBarVisibilityManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selectedTab) {
                HomeView()
                    .tabItem { Image(systemName: "house") }
                    .tag(0)

                SearchView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .tag(1)

                Color.clear
                    .tabItem { Image(systemName: "plus") }
                    .tag(2)

                NotificationsView()
                    .tabItem { Image(systemName: "bell") }
                    .tag(3)

                ProfileView()
                    .tabItem { Image(systemName: "person") }
                    .tag(4)
            }
            .onChange(of: viewModel.selectedTab) {
                viewModel.handleTabSelection()
            }


            .sheet(isPresented: $viewModel.isPresented) {
                BottomSheetView { image in
                    viewModel.selectedImageForForm = IdentifiableImage(image: image)
                }
                .presentationDetents([.fraction(0.4), .medium])
                .presentationDragIndicator(.visible)
            }

            .sheet(item: $viewModel.selectedImageForForm) { identifiable in
                NavigationStack {
                    PhotoFormView(image: identifiable.image)
                        .environmentObject(viewModel) // <-- ¡Clave!
                }
                .presentationDragIndicator(.visible)
            }

            .environmentObject(tabBarVisibility)
            .padding(.bottom, tabBarVisibility.isVisible ? 0 : -200)
            .animation(.easeInOut(duration: 0.5), value: tabBarVisibility.isVisible)
        }
        .onAppear {
            customizeTabBar()
            NotificationManager.shared.requestAuthorization()
        }
        .onChange(of: viewModel.shouldNavigateToMyPhotos) {
            if viewModel.shouldNavigateToMyPhotos {
                viewModel.selectedTab = 4 // Profile tab
                NotificationCenter.default.post(name: .navigateToMyPhotos, object: nil)
                viewModel.shouldNavigateToMyPhotos = false
            }
        }

        .onChange(of: scenePhase) {
            viewModel.handleScenePhaseChange(scenePhase)
        }
    }

    private func customizeTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainView()
}
