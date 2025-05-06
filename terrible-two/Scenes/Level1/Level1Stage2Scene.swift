//
//  Level1Stage2Scene.swift
//  terrible-two
//
//  Created by Samuel Andrey Aji Prasetya on 06/05/25.
//
import SpriteKit
import UIKit

class Level1Stage2Scene: SKScene {
    private var bayi: SKSpriteNode!
    private var bebek: SKSpriteNode!
    var box : SKSpriteNode!
    var isBoxClicked : Bool = false
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?

    override func didMove(to view: SKView) {
        // Set the scene's size to match the view
        size = view.bounds.size
        scaleMode = .aspectFill

        // Create the background sprite
        let background = SKSpriteNode(imageNamed: "level1_background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // Ensure background is behind other nodes
        background.size = size // Scale to fit the scene
        addChild(background)
        
        //create box
        box = SKSpriteNode(imageNamed: "box")
        box.size = CGSize(width: 50, height: 60)
        box.position = CGPoint(x: size.width * 0.15, y: size.height * 0.11)
        box.name = "box"
        addChild(box)

        // Create the foto sprite
        let foto = SKSpriteNode(imageNamed: "foto")
        foto.position = CGPoint(x: size.width / 2, y: size.height * 0.75) // Upper-center
        foto.zPosition = 0 // Above background, below bayi and bebek
        foto.size = CGSize(width: 40, height: 40) // Balanced size
        foto.name = "foto"
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
        bebek.size = CGSize(width: 50, height: 40) // Smaller size
        addChild(bebek)
        
        // Add swipe gestures right away
        addSwipeGestures()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
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
                        self.bayi.texture = SKTexture(imageNamed: "bayiidle")
                    }
                    let sequence = SKAction.sequence([moveAction, revertTextureAction])
                    bayi.run(sequence)
                }
                break
            } else if node.name == "foto" {
                // Calculate position below the foto node, aligned vertically
                let targetPosition = CGPoint(x: node.position.x, y: size.height * 0.25) // Same x as foto, y at lower quadrant
                
                // Check if bayi is already near the target position
                let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)
                if distance > 20 { // Move if more than 20 points away
                    // Change bayi texture to bayijalan
                    bayi.texture = SKTexture(imageNamed: "bayijalan")
                    
                    // Move bayi to the target position
                    let moveAction = SKAction.move(to: targetPosition, duration: 2.0) // 2 seconds to move
                    let changeToCryingAction = SKAction.run {
                        // Change to bayinangis texture
                        self.bayi.texture = SKTexture(imageNamed: "bayinangis")
                    }
                    let waitAction = SKAction.wait(forDuration: 3.0) // Wait for 3 seconds
                    let revertTextureAction = SKAction.run {
                        // Revert to original bayi texture
                        self.bayi.texture = SKTexture(imageNamed: "bayiidle")
                    }
                    let sequence = SKAction.sequence([moveAction, changeToCryingAction, waitAction, revertTextureAction])
                    bayi.run(sequence)
                    
                } else {
                    // Change to bayinangis texture
                    let changeToCryingAction = SKAction.run {
                        self.bayi.texture = SKTexture(imageNamed: "bayinangis")
                    }
                    let waitAction = SKAction.wait(forDuration: 3.0) // Wait for 3 seconds
                    let revertTextureAction = SKAction.run {
                        // Revert to original bayi texture
                        self.bayi.texture = SKTexture(imageNamed: "bayiidle")
                    }
                    let sequence = SKAction.sequence([changeToCryingAction, waitAction, revertTextureAction])
                    bayi.run(sequence)
                }
                break
            }
            else if node.name == "box" {
                isBoxClicked.toggle()
                box.color = isBoxClicked ? .red : .white
                box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0
                
                // If the box is clicked, move bayi next to the box
                if isBoxClicked {
                    // Calculate position to the left of box
                    let boxLeftEdge = box.position.x - (box.size.width / 2) - (bayi.size.width / 2) - 10 // 10-point gap
                    let targetPosition = CGPoint(x: boxLeftEdge, y: box.position.y)

                    // Check if bayi is already near the target position
                    let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)
                    if distance > 20 { // Only move if more than 20 points away
                        // Change bayi texture to bayijalan
                        bayi.texture = SKTexture(imageNamed: "bayijalan")

                        // Move bayi to the target position
                        let moveAction = SKAction.move(to: targetPosition, duration: 2.0) // 2 seconds to move
                        let revertTextureAction = SKAction.run {
                            // Revert to original bayi texture after moving
                            self.bayi.texture = SKTexture(imageNamed: "bayiidle")
                        }
                        let sequence = SKAction.sequence([moveAction, revertTextureAction])
                        bayi.run(sequence)
                    }
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
        
        // Handle bebek flip regardless of box state
        if bebek.frame.contains(sceneLocation) {
            // Flip bebek ke kanan
            let flipAction = SKAction.scaleX(to: -1, duration: 0.5)
            bebek.run(flipAction)
        }
        
        // Move box and bayi if box is clicked
        if isBoxClicked {
            // Change bayi texture to walking
            bayi.texture = SKTexture(imageNamed: "bayijalan")
            
            // Define movement parameters
            let moveDistance: CGFloat = 50.0
            let moveDuration: TimeInterval = 0.5
            
            // Gerakkan bayi dan box ke kanan
            let moveRight = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)
            let revertTextureAction = SKAction.run {
                // Revert to original bayi texture after moving
                self.bayi.texture = SKTexture(imageNamed: "bayiidle")
            }
            
            // Apply movement to bayi with texture change
            let sequence = SKAction.sequence([moveRight, revertTextureAction])
            bayi.run(sequence)
            
            // Just move the box without texture change
            box.run(moveRight)
            
            // Optional: Add boundaries check to prevent moving off-screen
            if bayi.position.x + moveDistance > size.width - bayi.size.width/2 ||
               box.position.x + moveDistance > size.width - box.size.width/2 {
                // Don't allow movement beyond screen edges
                return
            }
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
        
        // Move box and bayi if box is clicked
        if isBoxClicked {
            // Change bayi texture to walking
            bayi.texture = SKTexture(imageNamed: "bayijalan")
            
            // Define movement parameters
            let moveDistance: CGFloat = -50.0  // Negative for left movement
            let moveDuration: TimeInterval = 0.5
            
            // Gerakkan bayi dan box ke kiri
            let moveLeft = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)
            let revertTextureAction = SKAction.run {
                // Revert to original bayi texture after moving
                self.bayi.texture = SKTexture(imageNamed: "bayiidle")
            }
            
            // Apply movement to bayi with texture change
            let sequence = SKAction.sequence([moveLeft, revertTextureAction])
            bayi.run(sequence)
            
            // Just move the box without texture change
            box.run(moveLeft)
            
            // Optional: Add boundaries check to prevent moving off-screen
            if bayi.position.x + moveDistance < bayi.size.width/2 ||
               box.position.x + moveDistance < box.size.width/2 {
                // Don't allow movement beyond screen edges
                return
            }
        }
    }
}
