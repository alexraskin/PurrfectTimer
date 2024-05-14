//
//  CountdownViewModel.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import Combine

class CountdownViewModel: ObservableObject {
    @Published var timeRemaining: String = "Calculating..."
    private var timer: AnyCancellable?
    private var targetDate: Date
    
    init(targetDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.targetDate = formatter.date(from: targetDate) ?? Date()
        startCountdown()
    }
    
    func startCountdown() {
        updateCountdown()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateCountdown()
            }
    }
    
    func updateCountdown() {
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
}
