//
//  NotificationManager.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
