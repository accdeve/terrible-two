//
//  Level1View.swift
//  terrible-two
//
//  Created by Samuel Andrey Aji Prasetya on 06/05/25.
//

import SpriteKit
import SwiftUI

struct Level1View: View {

    var scene: SKScene {
        let scene = Level1Stage1Scene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }

}

#Preview {
    Level1View()
}
