//
//  ContentView.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
  
  @Environment(AppModel.self) private var appModel
  @Environment(\.openWindow) private var openWindow
  @Environment(\.dismissWindow) private var dismissWindow
  
  var body: some View {
    VStack {
      if appModel.openWebView {
        WebView()
      } else {
        Text("Hello Candidate")
        ToggleImmersiveSpaceButton(
          startComplition: {
            Task { @MainActor in
              openWindow(id: "Timer")
              dismissWindow(id: "General")
            }
            
          }) {
            Task { @MainActor in
              dismissWindow(id: "Timer")
              openWindow(id: "General")
            }
          }
      }
    }
  }
  
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(AppModel())
}
