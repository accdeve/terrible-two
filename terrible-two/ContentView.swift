//
//  ContentView.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 04/05/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = level_1_2(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
