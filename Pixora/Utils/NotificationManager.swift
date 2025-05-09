//
//  NotificationManager.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error al pedir permiso: \(error)")
            } else {
                print("Permiso concedido: \(granted)")
            }
        }
    }

    func scheduleNotification(title: String, body: String, inSeconds seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error al programar notificación: \(error)")
            } else {
                print("Notificación programada en \(seconds) segundos")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
