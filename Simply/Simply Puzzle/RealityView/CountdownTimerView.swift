//
//  CountdownTimerView.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/5/25.
//

import SwiftUI

struct CountdownTimerView: View {
  
  @State private var remainingTime: Int
  @State private var timer: Timer?
  
  init() {
    _remainingTime = State(initialValue: 180)
  }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
        .frame(width: 200, height: 200)
      
      Circle()
        .trim(from: 0, to: CGFloat(remainingTime) / CGFloat(150))
        .stroke(AngularGradient(gradient: Gradient(colors: [.blue, .cyan, .purple]), center: .center), lineWidth: 8)
        .frame(width: 200, height: 200)
        .rotationEffect(.degrees(-90))
        .animation(.easeInOut(duration: 1), value: remainingTime)
      
      Text(timeString(from: remainingTime))
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .monospacedDigit()
    }
    .onAppear(perform: startTimer)
    .onDisappear(perform: stopTimer)
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if remainingTime > 0 {
        remainingTime -= 1
      } else {
        stopTimer()
      }
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func timeString(from totalSeconds: Int) -> String {
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
  
}
