//
//  CountdownManager.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import Combine
import UserNotifications

class CountdownManager: ObservableObject {
    @Published var timers: [CountdownTimer] = [] {
        didSet {
            saveTimers()
        }
    }
    
    init() {
        loadTimers()
    }
    
    func addTimer(title: String, targetDate: Date) {
        let newTimer = CountdownTimer(title: title, targetDate: targetDate)
        timers.append(newTimer)
    }
    
    func removeTimer(at offsets: IndexSet) {
        let removedTimers = offsets.map { timers[$0] }
        removedTimers.forEach { $0.cancelNotification() }
        timers.remove(atOffsets: offsets)
    }
    
    func removeAllTimers() {
        timers.forEach { $0.cancelNotification() }
        timers.removeAll()
    }
    
    private func saveTimers() {
        do {
            let data = try JSONEncoder().encode(timers)
            UserDefaults.standard.set(data, forKey: "timers")
        } catch {
            print("Failed to save timers: \(error.localizedDescription)")
        }
    }
    
    private func loadTimers() {
        guard let data = UserDefaults.standard.data(forKey: "timers") else { return }
        do {
            timers = try JSONDecoder().decode([CountdownTimer].self, from: data)
        } catch {
            print("Failed to load timers: \(error.localizedDescription)")
        }
    }
}

class CountdownTimer: Identifiable, ObservableObject, Codable {
    let id: UUID
    let title: String
    let targetDate: Date
    @Published var timeRemaining: String = "Calculating..."
    private var timer: AnyCancellable?
    
    init(id: UUID = UUID(), title: String, targetDate: Date) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
        startCountdown()
        scheduleNotification()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case targetDate
    }
    
    private func startCountdown() {
        updateCountdown()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }
    
    private func updateCountdown() {
        let now = Date()
        let remainingTime = targetDate.timeIntervalSince(now)
        
        if remainingTime > 0 {
            let days = Int(remainingTime) / (24 * 3600)
            let hours = (Int(remainingTime) % (24 * 3600)) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60
            let seconds = Int(remainingTime) % 60
            
            timeRemaining = String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
        } else {
            timeRemaining = "00:00:00:00"
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "The countdown has ended!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: targetDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    func restartCountdown() {
        startCountdown()
    }
}
