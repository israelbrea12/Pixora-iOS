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
    
    // MARK: - Publisheds
    @Published var selectedTab: Int = 0
    @Published var previousTab: Int = 0
    @Published var isPresented: Bool = false
    @Published var selectedImageForForm: IdentifiableImage? = nil
    @Published var isTabBarVisible: Bool = true
    @Published var shouldNavigateToMyPhotos = false

    
    // MARK: - Use Cases
    let notificationUseCase: NotificationUseCase
    
    
    // MARK: - Lifecycle functions
    init(notificationUseCase: NotificationUseCase) {
        self.notificationUseCase = notificationUseCase
    }
    
    
    // MARK: - Functions
    func handleTabSelection() {
        if selectedTab == 2 {
            selectedTab = previousTab
            isPresented = true
        } else {
            previousTab = selectedTab
        }
    }
    
    func handleScenePhaseChange(_ phase: ScenePhase) {
        notificationUseCase.handleScenePhaseChange(phase)
    }
}
