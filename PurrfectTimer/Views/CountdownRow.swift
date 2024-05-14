//
//  CountdownRow.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import SwiftUI

struct CountdownRow: View {
    @ObservedObject var timer: CountdownTimer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(timer.title)
                .font(.headline)
                .foregroundColor(.primary) // Adapts to light/dark mode
            
            HStack {
                Text(timer.timeRemaining)
                    .font(.title)
                    .foregroundColor(.secondary) // Adapts to light/dark mode
                Spacer()
                Text(timer.targetDate, style: .date)
                    .foregroundColor(.secondary) // Adapts to light/dark mode
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Adapts to light/dark mode
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct CountdownRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownRow(timer: CountdownTimer(title: "Sample Timer", targetDate: Date().addingTimeInterval(3600)))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CountdownRow(timer: CountdownTimer(title: "Sample Timer", targetDate: Date().addingTimeInterval(3600)))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
