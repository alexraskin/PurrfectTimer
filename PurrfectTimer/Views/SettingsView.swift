//
//  SettingsView.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var countdownManager: CountdownManager
    @State private var showingResetAlert = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    .onChange(of: notificationsEnabled) { value in
                        if value {
                            NotificationManager.shared.requestAuthorization()
                        }
                    }
                    
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("Delete All Timers")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showingResetAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("This will delete all timers."),
                            primaryButton: .destructive(Text("Delete")) {
                                countdownManager.removeAllTimers()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                Section(header: Text("About")) {
                    Link("GitHub Repository", destination: URL(string: "https://github.com/your-repo")!)
                    Text("Made with ❤️ in Arizona")
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text("Version \(version)")
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(countdownManager: CountdownManager())
    }
}
