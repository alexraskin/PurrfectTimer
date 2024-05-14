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
    @State private var showingInvalidDateAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Timer Title", text: $title)
                
                DatePicker("Select Date", selection: $targetDate, displayedComponents: [.date, .hourAndMinute])
                
                Button(action: {
                    if targetDate < Date() {
                        showingInvalidDateAlert = true
                    } else {
                        countdownManager.addTimer(title: title, targetDate: targetDate)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Add Timer")
                }
                .disabled(title.isEmpty)
                .alert(isPresented: $showingInvalidDateAlert) {
                    Alert(
                        title: Text("Invalid Date"),
                        message: Text("Please select a date and time in the future."),
                        dismissButton: .default(Text("OK"))
                    )
                }
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
