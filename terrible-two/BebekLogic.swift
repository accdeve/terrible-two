//
//  BebekLogic.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    private var bayi: SKSpriteNode!
    private var bebek: SKSpriteNode!
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?

    override func didMove(to view: SKView) {
        // Set the scene's size to match the view
        size = view.bounds.size
        scaleMode = .aspectFill

        // Create the background sprite
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // Ensure background is behind other nodes
        background.size = size // Scale to fit the scene
        addChild(background)

        // Create the foto sprite
        let foto = SKSpriteNode(imageNamed: "foto")
        foto.position = CGPoint(x: size.width / 2, y: size.height * 0.75) // Upper-center
        foto.zPosition = 0 // Above background, below bayi and bebek
        foto.size = CGSize(width: 100, height: 100) // Balanced size
        addChild(foto)

        // Create the bayi (baby) sprite
        bayi = SKSpriteNode(imageNamed: "bayi")
        bayi.position = CGPoint(x: size.width * 0.25, y: size.height * 0.25) // Lower-left quadrant
        bayi.zPosition = 1 // Above background and foto
        bayi.name = "bayi" // Name for identification
        bayi.size = CGSize(width: 60, height: 60) // Smaller size
        addChild(bayi)

        // Create the bebek (toy duck) sprite
        bebek = SKSpriteNode(imageNamed: "bebek")
        bebek.position = CGPoint(x: size.width * 0.75, y: size.height * 0.25) // Lower-right quadrant
        bebek.zPosition = 1 // Above background and foto
        bebek.name = "bebek" // Name for identification
        bebek.size = CGSize(width: 40, height: 40) // Smaller size
        addChild(bebek)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        // Check if the bebek node was clicked
        for node in nodesAtPoint {
            if node.name == "bebek" {
                // Calculate position to the left of bebek
                let bebekLeftEdge = bebek.position.x - (bebek.size.width / 2) - (bayi.size.width / 2) - 10 // 10-point gap
                let targetPosition = CGPoint(x: bebekLeftEdge, y: bebek.position.y)

                // Check if bayi is already near the target position
                let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)
                if distance > 20 { // Only move if more than 20 points away
                    // Change bayi texture to bayijalan
                    bayi.texture = SKTexture(imageNamed: "bayijalan")

                    // Move bayi to the target position
                    let moveAction = SKAction.move(to: targetPosition, duration: 2.0) // 2 seconds to move
                    let revertTextureAction = SKAction.run {
                        // Revert to original bayi texture after moving
                        self.bayi.texture = SKTexture(imageNamed: "bayi")
                        // Add swipe gesture recognizers
                        self.addSwipeGestures()
                    }
                    let sequence = SKAction.sequence([moveAction, revertTextureAction])
                    bayi.run(sequence)
                }
                break
            }
        }
    }

    private func addSwipeGestures() {
        // Remove existing recognizers to avoid duplicates
        if let swipeRight = swipeRightRecognizer {
            view?.removeGestureRecognizer(swipeRight)
        }
        if let swipeLeft = swipeLeftRecognizer {
            view?.removeGestureRecognizer(swipeLeft)
        }

        // Create swipe right recognizer
        swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightRecognizer?.direction = .right
        if let swipeRight = swipeRightRecognizer {
            view?.addGestureRecognizer(swipeRight)
        }

        // Create swipe left recognizer
        swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftRecognizer?.direction = .left
        if let swipeLeft = swipeLeftRecognizer {
            view?.addGestureRecognizer(swipeLeft)
        }
    }

    @objc private func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        // Get the location of the swipe in the scene
        let location = sender.location(in: view)
        let sceneLocation = convertPoint(fromView: location)
        
        // Check if the swipe location is within the bebek node's frame
        if bebek.frame.contains(sceneLocation) {
            // Flip bebek horizontally (mirror image)
            let flipAction = SKAction.scaleX(to: -1, duration: 0.5)
            bebek.run(flipAction)
        }
    }

    @objc private func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        // Get the location of the swipe in the scene
        let location = sender.location(in: view)
        let sceneLocation = convertPoint(fromView: location)
        
        // Check if the swipe location is within the bebek node's frame
        if bebek.frame.contains(sceneLocation) {
            // Flip bebek back to original orientation
            let flipAction = SKAction.scaleX(to: 1, duration: 0.5)
            bebek.run(flipAction)
        }
    }
}

