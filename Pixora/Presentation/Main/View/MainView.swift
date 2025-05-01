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
            Group {
                switch viewModel.selectedTab {
                case 0: HomeView().environmentObject(tabBarVisibility)
                case 1: SearchView().environmentObject(tabBarVisibility)
                case 2: Color.clear // Este es el botón central (Plus)
                case 3: NotificationsView().environmentObject(tabBarVisibility)
                case 4: ProfileView().environmentObject(tabBarVisibility)
                default: HomeView().environmentObject(tabBarVisibility)
                }
            }
            .transition(.opacity)

            CustomTabBar(selectedTab: $viewModel.selectedTab)
                .onChange(of: viewModel.selectedTab) {
                    viewModel.handleTabSelection()
                }


                .sheet(isPresented: $viewModel.isPresented) {
                    BottomSheetView { image in
                        viewModel.selectedImageForForm = IdentifiableImage(
                            image: image
                        )
                    }
                    .presentationDetents([.fraction(0.4), .medium])
                    .presentationDragIndicator(.visible)
                }
                .presentationCompactAdaptation(.popover)

                .sheet(item: $viewModel.selectedImageForForm) { identifiable in
                    NavigationStack {
                        PhotoFormView(image: identifiable.image)
                            .environmentObject(viewModel)
                    }
                    .presentationDragIndicator(.visible)
                }

                .environmentObject(tabBarVisibility)
                .offset(y: tabBarVisibility.isVisible ? 0 : 100)
                .animation(
                    .easeInOut(duration: 0.5),
                    value: tabBarVisibility.isVisible
                )
        }
        .onAppear {
            customizeTabBar()
            NotificationManager.shared.requestAuthorization()
        }
        .onChange(of: viewModel.shouldNavigateToMyPhotos) {
            if viewModel.shouldNavigateToMyPhotos {
                viewModel.selectedTab = 4

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    NotificationCenter.default.post(name: .navigateToMyPhotos, object: nil)
                    viewModel.shouldNavigateToMyPhotos = false
                }
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
