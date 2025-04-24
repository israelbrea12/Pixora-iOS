//
//  MainViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 24/4/25.
//

import Foundation
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var previousTab: Int = 0
    @Published var isPresented: Bool = false
    @Published var selectedImageForForm: IdentifiableImage? = nil
    @Published var isTabBarVisible: Bool = true
    @Published var shouldNavigateToMyPhotos = false

    
    private let notificationManager: NotificationManagerProtocol
    
    init(notificationManager: NotificationManagerProtocol = NotificationManager.shared) {
        self.notificationManager = notificationManager
    }
    
    func handleTabSelection() {
        if selectedTab == 2 {
            selectedTab = previousTab
            isPresented = true
        } else {
            previousTab = selectedTab
        }
    }
    
    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
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
