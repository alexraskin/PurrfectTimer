//
//  AddTimerView.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import SwiftUI

struct AddTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var countdownManager: CountdownManager
    @State private var title: String = ""
    @State private var targetDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Timer Title", text: $title)
                
                DatePicker("Select Date", selection: $targetDate, displayedComponents: [.date, .hourAndMinute])
                
                Button(action: {
                    countdownManager.addTimer(title: title, targetDate: targetDate)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Timer")
                }
                .disabled(title.isEmpty)
            }
            .navigationBarTitle("New Timer")
        }
    }
}

struct AddTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerView(countdownManager: CountdownManager())
    }
}

