//
//  SimplyApp.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import SwiftUI

@main
struct SimplyApp: App {
  
  @State private var appModel = AppModel()
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  
  init() {
    GestureComponent.registerComponent()
  }
  
  var body: some Scene {
    WindowGroup(id: "General") {
      ContentView()
        .environment(appModel)
        .onChange(of: appModel.openWebView) { oldValue, newValue in
          if newValue {
            Task {
              await dismissImmersiveSpace()
            }
          }
        }
    }
    
    WindowGroup(id: "Timer") {
      CountdownTimerView()
        .environment(appModel)
    }
    .defaultSize(CGSize(width: 200, height: 300))
    
    ImmersiveSpace(id: appModel.immersiveSpaceID) {
      ImmersivePuzzle()
        .environment(appModel)
        .onAppear {
          appModel.immersiveSpaceState = .open
        }
        .onDisappear {
          appModel.immersiveSpaceState = .closed
        }
    }
    .immersionStyle(selection: .constant(.automatic), in: .automatic)
  }
  
}
