//
//  ContentView.swift
//  PurrfectTimer
//
//  Created by Alexander Raskin on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var countdownManager = CountdownManager()
    @State private var showingAddTimerSheet = false
    @State private var showingSettingsSheet = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach($countdownManager.timers) { $timer in
                    CountdownRow(timer: timer)
                }
                .onDelete(perform: countdownManager.removeTimer)
            }
            .navigationBarTitle("PurrfectTimer")
            .navigationBarItems(
                leading: Button(action: {
                    showingSettingsSheet.toggle()
                }) {
                    Image(systemName: "gear")
                },
                trailing: Button(action: {
                    showingAddTimerSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(isPresented: $showingAddTimerSheet) {
            AddTimerView(countdownManager: countdownManager)
        }
        .sheet(isPresented: $showingSettingsSheet) {
            SettingsView(countdownManager: countdownManager)
        }
        .onAppear {
            if notificationsEnabled {
                NotificationManager.shared.requestAuthorization()
            }
            for timer in countdownManager.timers {
                timer.restartCountdown()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
