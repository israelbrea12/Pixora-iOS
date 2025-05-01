//
//  NotificationUseCaseProtocol.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 1/5/25.
//

import SwiftUI

protocol NotificationUseCaseProtocol {
    func handleScenePhaseChange(_ phase: ScenePhase)
}

final class NotificationUseCase: NotificationUseCaseProtocol {
    private let notificationManager: NotificationManagerProtocol

    init(
        notificationManager: NotificationManagerProtocol = NotificationManager.shared
    ) {
        self.notificationManager = notificationManager
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background:
            notificationManager.scheduleNotification(
                title: "Pixora",
                body: "Explora y comparte fotos con la comunidad ¡Qué divertido!",
                inSeconds: 5
            )
            notificationManager.scheduleNotification(
                title: "Pixora",
                body: "Pixora te echa de menos 😢 ¡Vuelve y mira las nuevas fotos increíbles!",
                inSeconds: 30
            )
        case .active:
            notificationManager.cancelAllNotifications()
        default: break
        }
    }
}
