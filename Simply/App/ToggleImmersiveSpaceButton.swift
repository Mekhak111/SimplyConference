//
//  ToggleImmersiveSpaceButton.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {
  
  @Environment(AppModel.self) private var appModel
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  
  var startComplition: (() -> Void)
  var finishComplition: (() -> Void)
  
  var body: some View {
    Button {
      Task { @MainActor in
        switch appModel.immersiveSpaceState {
        case .open:
          appModel.immersiveSpaceState = .inTransition
          appModel.openWebView = false
          finishComplition()
          await dismissImmersiveSpace()
        case .closed:
          startComplition()
          appModel.immersiveSpaceState = .inTransition
          switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
          case .opened:
            break
          case .userCancelled, .error:
            fallthrough
          @unknown default:
            appModel.immersiveSpaceState = .closed
          }
        case .inTransition:
          break
        }
      }
    } label: {
      Text(appModel.immersiveSpaceState == .open ? "Finish" : "Start The Game")
    }
    .disabled(appModel.immersiveSpaceState == .inTransition)
    .animation(.none, value: 0)
    .fontWeight(.semibold)
  }
  
}
