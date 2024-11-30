//
//  ContentView.swift
//  KItimer
//
//  Created by Tomoya on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            headerView().padding(.bottom, 50)
            
            VStack {
                Text("Drink Pass")
                    .font(.title)
                TimerView(
                    totalTime: 15 * 60,
                    notificationTitle: "Your Drink Pass Available!",
                    notificationBody: "It's time to enjoy your next drink!",
                    displayFormat: "mm:ss"
                ).padding(.bottom, 50)
                                                
                Text("Dining Pass")
                    .font(.title)
                TimerView(
                    totalTime: 4 * 60 * 60,
                    notificationTitle: "Your Dining Pass Available!",
                    notificationBody: "Your dining pass is ready!",
                    displayFormat: "hh:mm:ss"
                )
            }
            .padding()
            
            Spacer()
        }
        .background(Color(red: 0.93, green: 0.98, blue: 0.99))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
    
    // ヘッダーを作成
    @ViewBuilder
    private func headerView() -> some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.top)
            Text("KItimer")
                .font(.largeTitle)
                .frame(alignment: .center)
                .foregroundColor(.white)
                .padding(.top, 50)
                .padding()
        }
        .frame(height: 120)
    }
}
