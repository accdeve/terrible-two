//
//  Level1View.swift
//  terrible-two
//
//  Created by Samuel Andrey Aji Prasetya on 06/05/25.
//

import SpriteKit
import SwiftUI

struct Level1View: View {
    
    @StateObject private var gameState = GameState()
    @State private var navigateToNext = false
    
    var scene: SKScene {
        let scene = Level1Stage1Scene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.gameState = gameState
        return scene
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()

//                    .fullScreenCover(isPresented: $navigateToNext) {
//                        Level12View()
//                            .transition(.opacity)
//                            .background(Color.black) // start with dark
//                    }

            }
        }
        .onReceive(gameState.$isFinish) { isFinish in
            if isFinish {
                navigateToNext = true
            }
        }
    }
}


#Preview {
    Level1View()
}
