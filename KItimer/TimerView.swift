//
//  TimerView.swift
//  KItimer
//
//  Created by Tomoya on 11/30/24.
//

import SwiftUI

struct TimerView: View {
    @State private var isRunning = false
    @State private var timeRemaining: TimeInterval
    @State private var showResetButton = false
    @State private var timer: Timer? = nil
    let totalTime: TimeInterval
    let notificationTitle: String
    let notificationBody: String
    let displayFormat: String
    
    init(totalTime: TimeInterval, notificationTitle: String, notificationBody: String, displayFormat: String) {
        self.totalTime = totalTime
        self.notificationTitle = notificationTitle
        self.notificationBody = notificationBody
        self.displayFormat = displayFormat
        _timeRemaining = State(initialValue: totalTime)
    }
    
    var body: some View {
        VStack {
            Text(formatTime(timeRemaining))
                .font(.largeTitle)
                .monospacedDigit()
                .padding()
            
            HStack {
                Button(action: startTimer) {
                    Text("Start")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRunning ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isRunning)
                
                if showResetButton {
                    Button(action: resetTimer) {
                        Text("Reset")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        isRunning = true
        showResetButton = true
        NotificationManager.shared.scheduleNotification(
            title: notificationTitle,
            body: notificationBody,
            timeInterval: totalTime
        )
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
                self.isRunning = false
            }
        }
    }
    
    private func resetTimer() {
        isRunning = false
        showResetButton = false
        timeRemaining = totalTime
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        
        if displayFormat == "mm:ss" {
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

