//
//  AppModel.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import SwiftUI

@MainActor
@Observable
class AppModel {
  
  let immersiveSpaceID = "ImmersiveSpace"
  enum ImmersiveSpaceState {
    case closed
    case inTransition
    case open
  }
  var immersiveSpaceState = ImmersiveSpaceState.closed
  var openWebView: Bool = false
  
}
