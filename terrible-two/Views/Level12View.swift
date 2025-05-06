//
//  Level12View.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//


import SpriteKit
import SwiftUI

struct Level12View: View {
    var scene: SKScene {
        let scene = Level1Stage2Scene()
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }

}

#Preview {
    Level12View()
}
