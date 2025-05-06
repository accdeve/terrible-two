//
//  InteractUnreachableObjects.swift
//  terrible-two
//
//  Created by steven on 06/05/25.
//

import SwiftUI
import SpriteKit
import Combine

class InteractUnreachableObjects: SKScene{
    var baby: SKSpriteNode!
    var pictureFrame: SKSpriteNode!
    var pictureFrame2: SKSpriteNode!
    var background: SKSpriteNode!
    
    func createBaby(){
        baby = SKSpriteNode(imageNamed: "baby_forward1")
        baby.position = CGPoint(x: 275, y: size.height/2 - 50)
        baby.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        baby.zPosition = 2
        baby.size = CGSize(width: 200, height: 200)
        addChild(baby)
    }
    
    func createPictureFrame(){
        pictureFrame = SKSpriteNode(imageNamed: "bingkaiFoto")
        pictureFrame.name = "pictureFrame"
        pictureFrame.position = CGPoint(x: 650, y: size.height/2 + 50)
        pictureFrame.size = CGSize(width: 50, height: 50)
        pictureFrame.zPosition = 1
        addChild(pictureFrame)
    }
    
    func createpictureFrame2(){
        pictureFrame2 = SKSpriteNode(imageNamed: "bingkaiFoto")
        pictureFrame2.name = "pictureFrame2"
        pictureFrame2.position = CGPoint(x: 150, y: size.height/2 + 50)
        pictureFrame2.size = CGSize(width: 50, height: 50)
        pictureFrame2.zPosition = 1
        addChild(pictureFrame2)
    }
    
    func createBackground(){
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = CGSize(width: frame.width, height: frame.height)
        addChild(background)
    }
    
    func setupScene(){
        createBackground()
        createBaby()
        createPictureFrame()
        createpictureFrame2()
    }
    
    func walkForwardAnimation() -> SKAction{
        let walkFramesForward = (1...4).map { SKTexture(imageNamed: "baby_forward\($0)") }
        let walkForwardAnimation = SKAction.repeatForever(SKAction.animate(with: walkFramesForward, timePerFrame: 0.2))
        return walkForwardAnimation
    }
    
    func walkBackwardAnimation() -> SKAction{
        let walkFramesBackward = (1...3).map { SKTexture(imageNamed: "baby_backward\($0)") }
        let walkBackwardAnimation = SKAction.repeatForever(SKAction.animate(with: walkFramesBackward, timePerFrame: 0.2))
        return walkBackwardAnimation
    }
    
    func gapaiAnimation() -> SKAction{
        let gapai = [
            SKTexture(imageNamed: "baby_gapai1"),
            SKTexture(imageNamed: "baby_gapai2")
        ]
        
        let gapaiAnimation = SKAction.animate(with: gapai, timePerFrame: 0.5)
        let gapaiAnimationRepeat = SKAction.repeat(gapaiAnimation, count: 5)
        
        return gapaiAnimationRepeat
    }
    
    func ngambekAnimation() -> SKAction{
        let ngambek = [
            SKTexture(imageNamed: "baby_diem"),
            SKTexture(imageNamed: "baby_ngambek1"),
            SKTexture(imageNamed: "baby_ngambek2"),
            SKTexture(imageNamed: "baby_ngambek3"),
        ]
        
        let ngambekAnimation = SKAction.animate(with: ngambek, timePerFrame: 1)
        
        return ngambekAnimation
    }
    
    func delayAnimation() -> SKAction {
        let delay = SKAction.wait(forDuration: 3)
        return delay
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodeAtLocation = nodes(at: location)
        
        let pictureFramePosition = CGPoint(x: pictureFrame.position.x, y: pictureFrame.position.y - 100)
        let pictureFrame2Position = CGPoint(x: pictureFrame2.position.x, y: pictureFrame2.position.y - 100)

        nodeAtLocation.forEach{ node in
            // wall object
            if node.name?.contains("Frame") == true{
                if node.name == "pictureFrame" {
                    let move = SKAction.move(to: pictureFramePosition, duration: 2)
                    let walkForwardMoveAnimationGroup = SKAction.group([move, walkForwardAnimation()])
                    
                    baby.run(walkForwardMoveAnimationGroup, withKey: "walk")
                    baby.run(move){
                        self.baby.removeAction(forKey: "walk" )
                    }
                }
                else if node.name == "pictureFrame2" {
                    let move = SKAction.move(to: pictureFrame2Position, duration: 2)
                    let walkForwardMoveAnimationGroup = SKAction.group([move, walkForwardAnimation()])
                    
                    baby.run(walkForwardMoveAnimationGroup, withKey: "walk")
                    baby.run(move){
                        self.baby.removeAction(forKey: "walk" )
                    }
                }
                
                baby.run(delayAnimation()){
                    self.baby.run(self.gapaiAnimation()){
                        self.baby.run(self.ngambekAnimation())
                    }
                }
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        setupScene()
    }
}
