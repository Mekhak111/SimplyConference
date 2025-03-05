//
//  Letter.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import Foundation
import UIKit

enum Letter: String, CaseIterable {
  
  case s,i,m,p,l,y
  
  var color: UIColor {
    return switch self {
    case .s: UIColor.green
    case .i: UIColor.systemPink
    case .m: UIColor.systemIndigo
    case .p: UIColor.yellow
    case .l: UIColor.blue
    case .y: UIColor.systemOrange
    }
  }
  
  
  
}
