//
//  ImmersiveView.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//

import SwiftUI
import RealityKit

struct ImmersivePuzzle: View {
  
  @Environment(AppModel.self) private var appModel
  
  @State var content: RealityViewContent?
  @State private var subs: [String:EventSubscription] = [:]
  @State var collectedLetter: Int = 0
  @State var lastLetter: ModelEntity?
  @State var plane: ModelEntity?
  
  @Environment(\.openWindow) private var openWindow
  @Environment(\.dismissWindow) private var dismissWindow
  
  @State var letters = ["s","i","m","p","l","y"]
  
  var body: some View {
    RealityView { content in
      self.content = content
      var placeHolderX: Float = -1.5
      let planeMesh = MeshResource.generateBox(width: 3.0, height: 0.001, depth: 1.0)
      let material = SimpleMaterial(color: .gray.withAlphaComponent(0.5), isMetallic: false)
      let plane = ModelEntity(mesh: planeMesh, materials: [material])
      plane.generateCollisionShapes(recursive: true)
      plane.components.set(InputTargetComponent())
      plane.components.set(GestureComponent())
      self.plane = plane
      Letter.allCases.forEach { letter in
        let text = generateText(letter: letter)
        let placeHolder = generatePlaceholder(for: letter, positionX: placeHolderX)
        content.add(text)
        plane.addChild(placeHolder)
        startPlacementListener(for: text, placeholder: placeHolder)
        placeHolderX += 1
      }
      plane.position = [0,1.5,-2]
      content.add(plane)
    } update: { content in
      if letters.count == 0 {
        appModel.openWebView = true
      }
    }
    .installGestures()
    .onChange(of: letters, { oldValue, newValue in
      if newValue.count == 0 {
        Task { @MainActor in
          dismissWindow(id: "Timer")
          openWindow(id: "General")
        }
      }
    })
    
  }
  
}

extension ImmersivePuzzle {
  
  private func generateText(letter: Letter) -> Entity {
    let textMesh = MeshResource.generateText(
      letter.rawValue,
      extrusionDepth: 0.02,
      font: .systemFont(ofSize: 1, weight: .bold, width: .compressed),
      containerFrame: .zero,
      alignment: .center,
      lineBreakMode: .byWordWrapping
    )
    let materialColor = letter.color
    let material = SimpleMaterial(color: materialColor, isMetallic: false)
    let textEntity = ModelEntity(mesh: textMesh, materials: [material])
    textEntity.name = letter.rawValue
    let randomX = Float.random(in: -4.0...(-1.0))
    let fixedY: Float = 1.0
    let randomZ = Float.random(in: -4.0...0)
    textEntity.position = SIMD3(randomX, fixedY, randomZ)
    textEntity.generateCollisionShapes(recursive: true)
    textEntity.components.set(InputTargetComponent())
    textEntity.components.set(GestureComponent())
    return textEntity
  }
  
  private func generatePlaceholder(for letter: Letter, positionX: Float) -> ModelEntity {
    let textMesh = MeshResource.generateText(
      letter.rawValue,
      extrusionDepth: 0.02,
      font: .systemFont(ofSize: 1, weight: .bold, width: .compressed),
      containerFrame: .zero,
      alignment: .center,
      lineBreakMode: .byWordWrapping
    )
    let material = SimpleMaterial(color: .gray.withAlphaComponent(0.3), isMetallic: false)
    let textEntity = ModelEntity(mesh: textMesh, materials: [material])
    if let lastLetter {
      let width = (lastLetter.model?.mesh.bounds.max.x)! - (lastLetter.model?.mesh.bounds.min.x)!
      textEntity.setPosition(SIMD3(width + 0.1, 0, 0), relativeTo: lastLetter)
    } else {
      textEntity.setPosition(SIMD3(positionX, 0.1, 0), relativeTo: self.plane)
    }
    lastLetter = textEntity
    return textEntity
  }
  
  func startPlacementListener(for textEntity: Entity, placeholder: Entity) {
    let sub = content?.subscribe(to: SceneEvents.Update.self) { event in
      let distance = simd_distance(textEntity.position, placeholder.position(relativeTo: nil))
      if distance < 0.05 {
        textEntity.gestureComponent?.canDrag = false
        textEntity.position = placeholder.position
        placeholder.parent?.addChild(textEntity)
        placeholder.removeFromParent()
        collectedLetter +=  1
        letters.removeAll(where: {
          $0 == textEntity.name
        })
      }
    }
    guard let sub else { return }
    DispatchQueue.main.async {
      subs[textEntity.name] = sub
    }
  }
  
}

#Preview(immersionStyle: .full) {
  ImmersivePuzzle()
    .environment(AppModel())
}
