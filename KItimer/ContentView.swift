//
//  ContentView.swift
//  KItimer
//
//  Created by Tomoya on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            // ヘッダー部分の作成
            headerView()

            Spacer() // ヘッダーとタイマーの間にスペースを追加

            // ドリンクパスのタイマー (MM:SS形式)
            TimerView(
                title: "Drink Pass", // タイトルが目立つように強調
                duration: 15 * 60,
                actionTitle: "Start",
                displayInHours: false,
                onStart: {
                    NotificationManager.shared.scheduleNotification(
                        duration: 15 * 60,
                        identifier: "drinkPass",
                        title: "Drink Pass Available"
                    )
                }
            )

            // フードパスのタイマー (HH:MM:SS形式)
            TimerView(
                title: "Dining Pass", // タイトルが目立つように強調
                duration: 4 * 60 * 60,
                actionTitle: "Start",
                displayInHours: true,
                onStart: {
                    NotificationManager.shared.scheduleNotification(
                        duration: 4 * 60 * 60,
                        identifier: "foodPass",
                        title: "Dining Pass Available"
                    )
                }
            )

            Spacer() // タイマーと画面下部にスペースを追加
        }
        .background(Color(red: 0.93, green: 0.98, blue: 0.99)) // 背景色をRGBで設定
        .edgesIgnoringSafeArea(.all) // 画面全体に背景色を適用
        .onAppear {
            NotificationManager.shared.requestNotificationPermission()
        }
    }

    // ヘッダー部分を作成
    @ViewBuilder
    private func headerView() -> some View {
        ZStack {
            Color.blue // ヘッダーの背景色
                .edgesIgnoringSafeArea(.top)
            Text("KItimer")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40) // ダイナミックアイランドと干渉しないように上部にスペースを追加
                .padding()
        }
        .frame(height: 100) // ヘッダーの高さを設定
    }
}

struct TimerView: View {
    var title: String
    var duration: Int
    var actionTitle: String
    var displayInHours: Bool
    var onStart: () -> Void
    
    @State private var timeRemaining: Int
    @State private var timerIsActive: Bool = false
    @State private var showResetButton: Bool = false  // リセットボタンの表示フラグ
    @State private var timer: Timer? = nil  // タイマーインスタンスを保持

    
    init(title: String, duration: Int, actionTitle: String, displayInHours: Bool, onStart: @escaping () -> Void) {
        self.title = title
        self.duration = duration
        self.actionTitle = actionTitle
        self.displayInHours = displayInHours
        self.onStart = onStart
        _timeRemaining = State(initialValue: duration)
    }

    var body: some View {
        VStack {
            // タイトルを強調表示
            Text(title)
                .font(.title2)
                .fontWeight(.bold)  // タイトルを太字にして視認性を向上
                .padding(.bottom, 8)
            
            // タイマー表示 (HH:MM:SS形式 or MM:SS形式)
            Text(timeFormatted(timeRemaining))
                .font(.largeTitle)
                .padding(.vertical, 4)
            
            // 開始/停止ボタン
            Button(action: {
                if !timerIsActive {
                    onStart()
                    startTimer()
                    showResetButton = true // タイマー開始後にリセットボタンを表示
                } else {
                    stopTimer()
                }
            }) {
                Text(actionTitle)
                    .font(.title3)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(timerIsActive ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)
            
            // リセットボタンの表示
            if showResetButton {
                HStack {
                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                            .font(.title3)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
    }

    // タイマーの開始
    func startTimer() {
        timerIsActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerIsActive = false
            }
        }
    }

    // タイマーの停止
    func stopTimer() {
        timer?.invalidate()  // タイマーを無効化
        timerIsActive = false
    }

    // タイマーのリセット
    func resetTimer() {
        timeRemaining = duration  // 初期の時間に戻す
        timerIsActive = false  // タイマーを停止
        showResetButton = false // リセット後にリセットボタンを非表示に
    }

    // 時間のフォーマット (HH:MM:SSまたはMM:SS形式)
    func timeFormatted(_ seconds: Int) -> String {
        if displayInHours {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            let seconds = seconds % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            let minutes = seconds / 60
            let seconds = seconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}


#Preview {
    ContentView()
}
