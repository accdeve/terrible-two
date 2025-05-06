//
//  level_1_2.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 04/05/25.
//

import SpriteKit
import SwiftUI

class level_1_2: SKScene, SKPhysicsContactDelegate {
    var background : SKSpriteNode!
    var box : SKSpriteNode!
    var isBoxClicked : Bool = false;
    var baby :SKSpriteNode!
    var babyTextures = [
        SKTexture(imageNamed: "box"),
        SKTexture(imageNamed: "background_png")
    ]
    var currentTextureIndex = 0
    var textureTimer: Timer?
    
    private func setupScene() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        background = SKSpriteNode(imageNamed: "background_png")
        background.size = CGSize(width: 960, height: 580)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        box = SKSpriteNode(imageNamed: "box")
        box.size = CGSize(width: 100, height: 100)
        box.position = CGPoint(x: size.width/2, y: size.height/2)
        box.name = "box"
        addChild(box)
        
        baby = SKSpriteNode(imageNamed: "box")
        baby.size = CGSize(width: 150, height: 150)
        baby.position = CGPoint(x: size.width/2 - 200, y: size.height/2)
        addChild(baby)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let tappedNode = atPoint(location)
        
        if tappedNode.name == "box" {
            isBoxClicked.toggle()
            box.color = isBoxClicked ? .red : .white
            box.colorBlendFactor = 1.0
            let newPosition = CGPoint(x: box.position.x-120, y: box.position.y)
            baby.run(SKAction.move(to: newPosition, duration: 1))
            print(isBoxClicked)
        }
    }

    
    func setupSwipeGesturesBox(view: SKView){
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipe.direction = direction
            view.addGestureRecognizer(swipe)
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        let moveDistance: CGFloat = 100
        
        if(isBoxClicked == true){
            startTextureSwapping()
            switch sender.direction {
            case .left:
                let newPositionBox = CGPoint(x: box.position.x - moveDistance, y: box.position.y)
                let newPositionBaby = CGPoint(x: box.position.x-120 - moveDistance, y: box.position.y)
                box.run(SKAction.move(to: newPositionBox, duration: 0.2))
                baby.run(SKAction.move(to: newPositionBaby, duration: 0.2))
            case .right:
                let newPositionBox = CGPoint(x: box.position.x + moveDistance, y: box.position.y)
                let newPositionBaby = CGPoint(x: box.position.x-120 + moveDistance, y: box.position.y)
                box.run(SKAction.move(to: newPositionBox, duration: 0.2))
                baby.run(SKAction.move(to: newPositionBaby, duration: 0.2))
                
            default:
                break
            }
        } else{
            stopTextureSwapping()
        }
    }
    
    func startTextureSwapping() {
        textureTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentTextureIndex = (self.currentTextureIndex + 1) % self.babyTextures.count
            self.baby.texture = self.babyTextures[self.currentTextureIndex]
        }
    }

    func stopTextureSwapping() {
        textureTimer?.invalidate()
        textureTimer = nil
        baby.texture = babyTextures[0]
        currentTextureIndex = 0
    }


    
    override func didMove(to view: SKView) {
        setupScene()
        setupSwipeGesturesBox(view: view)
    }
}
