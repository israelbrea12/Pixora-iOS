//
//  NotificationManagerProtocol.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 24/4/25.
//

import Foundation

protocol NotificationManagerProtocol {
    func requestAuthorization()
    func scheduleNotification(title: String, body: String, inSeconds: TimeInterval)
    func cancelAllNotifications()
}

extension NotificationManager: NotificationManagerProtocol {}
