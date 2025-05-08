//
//  Level1Stage2Scene.swift
//  terrible-two
//
//  Created by Samuel Andrey Aji Prasetya on 06/05/25.
//

import SpriteKit
import UIKit

class Level1Stage2Scene: SKScene {
    var bayi: SKSpriteNode!
    var bebek: SKSpriteNode!
    var box : SKSpriteNode!
    var pictureFrame: SKSpriteNode!
    var background: SKSpriteNode!
    var isBoxClicked : Bool = false
    var door :SKSpriteNode!
    
    var isTeksDadIsComingActive = false
    var teksDadIsComing : SKLabelNode!
    
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    private var hasCameraSequenceRun = false
    private var cameraNode: SKCameraNode?


    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .aspectFill
        createBackground()
        createBaby()
        createBox()
        createBebek()
        createPictureFrame()
        addSwipeGestures()
        createCamera()
        createDoor()
        createTeksDadIsComing()
        teksDadIsComingController()
    }
    
    func createCamera(){
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        if let cameraNode = cameraNode {
            addChild(cameraNode)
        }
        cameraNode?.setScale(1)
        cameraNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    func createBaby(){
        bayi = SKSpriteNode(imageNamed: "baby_forward1")
        bayi.position = CGPoint(x: size.width * 0.25, y: size.height * 0.25)
        bayi.zPosition = 100
        bayi.name = "bayi"
        bayi.size = CGSize(width: 200, height: 200)
        addChild(bayi)
    }
    
    func createBebek(){
        bebek = SKSpriteNode(imageNamed: "bebekGround")
        bebek.position = CGPoint(x: size.width * 0.75, y: size.height * 0.25)
        bebek.zPosition = 1
        bebek.name = "bebekGround"
        bebek.size = CGSize(width: 50, height: 40)
        addChild(bebek)
        }
        
    func createPictureFrame(){
        pictureFrame = SKSpriteNode(imageNamed: "foto")
        pictureFrame.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        pictureFrame.zPosition = 0
        pictureFrame.size = CGSize(width: 40, height: 40)
        pictureFrame.name = "foto"
        addChild(pictureFrame)
    }
    
    func createBox(){
        box = SKSpriteNode(imageNamed: "boxGround")
        box.size = CGSize(width: 50, height: 60)
        box.position = CGPoint(x: size.width * 0.15, y: size.height * 0.11)
        box.name = "boxGround"
        addChild(box)
    }
    
    func createBackground(){
        background = SKSpriteNode(imageNamed: "level1_background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = size
        addChild(background)
    }
    
    func createDoor() {
        door = SKSpriteNode(color: .black, size: CGSize(width: 80, height: 60))
        door.position = CGPoint(x: size.width / 1.05, y: size.height / 2)
        door.zPosition = 0
        door.name = "door"
        addChild(door)
    }
    
    func createTeksDadIsComing() {
        teksDadIsComing = SKLabelNode(fontNamed: "Chalkduster")
        teksDadIsComing.text = "Dad is coming"
        teksDadIsComing.fontColor = .black
        teksDadIsComing.fontSize = 100
        teksDadIsComing.position = CGPoint(x: size.width / 2, y: size.height / 2)
        teksDadIsComing.alpha = 0.0
        teksDadIsComing.zPosition = 100
        addChild(teksDadIsComing)
    }
    
    func teksDadIsComingController() {
        let initialWait = SKAction.wait(forDuration: 5.0)
        let activateFlag = SKAction.run { [weak self] in
            self?.isTeksDadIsComingActive = true
            self?.showBlinkingText()
        }
        
        let waitBetweenRepeats = SKAction.wait(forDuration: 10.0)
        let sequence = SKAction.sequence([initialWait, activateFlag, waitBetweenRepeats])
        let repeatAction = SKAction.repeatForever(sequence)
        
        run(repeatAction, withKey: "teksDadIsComingController")
    }
    
    func showBlinkingText() {
        teksDadIsComing.alpha = 0.0

        let blinkOn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let blinkOff = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
        let blink = SKAction.sequence([blinkOff, blinkOn])
        let blinkRepeat = SKAction.repeat(blink, count: 5)

        let deactivateFlag = SKAction.run { [weak self] in
            self?.isTeksDadIsComingActive = false
        }

        let hideText = SKAction.run { [weak self] in
            self?.teksDadIsComing.alpha = 0.0
        }

        let sequence = SKAction.sequence([blinkRepeat, deactivateFlag, hideText])
        teksDadIsComing.run(sequence)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name?.contains("foto") == true{
                if node.name == "foto" {
                    if(isTeksDadIsComingActive){
                        let nextScene = Level1Stage1Scene()
                        nextScene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 1.0)
                        self.view?.presentScene(nextScene, transition: transition)
                    }
                    else{
                        let move = SKAction.move(to: CGPoint(x: pictureFrame.position.x, y: pictureFrame.position.y - 200), duration: 2)
                        let walkForwardMoveAnimationGroup = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                                           
                        bayi.run(walkForwardMoveAnimationGroup, withKey: "walk")
                        bayi.run(move){
                           self.bayi.removeAction(forKey: "walk")
                        }
                        bayi.run(WalkingAnimationBaby.delayAnimation()){
                            self.bayi.run(WalkingAnimationBaby.gapaiAnimation()){
                                self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
                            }
                        }
                    }
                    break
                }
            }
            else if node.name?.contains("Ground") == true{
                if node.name == "bebekGround" {
                    if(isTeksDadIsComingActive){
                        let nextScene = Level1Stage1Scene()
                        nextScene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 1.0)
                        self.view?.presentScene(nextScene, transition: transition)
                    }
                    else{
                        let move = SKAction.move(to: CGPoint(x: bebek.position.x - 20, y: bebek.position.y), duration: 2)
                        let walkForwardMoveAnimationGroup = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                                           
                        bayi.run(walkForwardMoveAnimationGroup, withKey: "walk")
                        bayi.run(move){
                           self.bayi.removeAction(forKey: "walk")
                        }
                        break
                    }
                   
               } else if node.name == "boxGround" {
                   if(isTeksDadIsComingActive){
                       let nextScene = Level1Stage1Scene()
                       nextScene.scaleMode = .aspectFill
                       let transition = SKTransition.fade(withDuration: 1.0)
                       self.view?.presentScene(nextScene, transition: transition)
                   } else{
                       isBoxClicked.toggle()
                       box.color = isBoxClicked ? .red : .white
                       box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0
                       
                       if isBoxClicked {
                           if !hasCameraSequenceRun {
                               hasCameraSequenceRun = true
                               if let cameraNode = cameraNode {
                                   let zoomIn = SKAction.scale(to: 0.5, duration: 1.0)
                                   let moveToBayi = SKAction.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.25), duration: 1.0)
                                   let bayiFollowGroup = SKAction.group([zoomIn, moveToBayi])
                                   
                                   let wait1 = SKAction.wait(forDuration: 1.0)
                                   let moveToDoor = SKAction.move(to: CGPoint(x: size.width / 1.35, y: size.height / 2), duration: 1.0)
                                   let wait2 = SKAction.wait(forDuration: 1.0)
                                   let zoomOut = SKAction.scale(to: 1.0, duration: 1.0)
                                   let moveToCenter = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: 1.0)
                                   let zoomOutGroup = SKAction.group([zoomOut, moveToCenter])
                                   
                                   let sequence = SKAction.sequence([
                                       bayiFollowGroup,
                                       wait1,
                                       moveToDoor,
                                       wait2,
                                       zoomOutGroup
                                   ])
                                   
                                   cameraNode.run(sequence)
                               }
                           }

                           let move = SKAction.move(to: CGPoint(x: box.position.x - 20, y: box.position.y), duration: 2)
                           let walkForwardMoveAnimationGroup = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                           
                           bayi.run(walkForwardMoveAnimationGroup, withKey: "walk")
                           bayi.run(move){
                               self.bayi.removeAction(forKey: "walk")
                           }
                       }


                       else {
                           if let cameraNode = cameraNode {
                               let zoomOut = SKAction.scale(to: 1.0, duration: 1.0)
                               let moveToCenter = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: 1.0)
                               let group = SKAction.group([zoomOut, moveToCenter])
                               cameraNode.run(group)
                           }
                           }
                       break
                   }
                   
               }
            }
             
        }
    }
    
    private func addSwipeGestures() {
        if let swipeRight = swipeRightRecognizer {
            view?.removeGestureRecognizer(swipeRight)
        }
        if let swipeLeft = swipeLeftRecognizer {
            view?.removeGestureRecognizer(swipeLeft)
        }

        swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightRecognizer?.direction = .right
        if let swipeRight = swipeRightRecognizer {
            view?.addGestureRecognizer(swipeRight)
        }

        swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftRecognizer?.direction = .left
        if let swipeLeft = swipeLeftRecognizer {
            view?.addGestureRecognizer(swipeLeft)
        }
    }

    @objc private func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        let location = sender.location(in: view)
        let sceneLocation = convertPoint(fromView: location)
        
        if bebek.frame.contains(sceneLocation) {
            let flipAction = SKAction.scaleX(to: -1, duration: 0.5)
            bebek.run(flipAction)
        }
        
        if isBoxClicked {
            bayi.texture = SKTexture(imageNamed: "bayiidle")
            
            let moveDistance: CGFloat = 50.0
            let moveDuration: TimeInterval = 0.5
            
            let moveRight = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)
            let revertTextureAction = SKAction.run {
                self.bayi.texture = SKTexture(imageNamed: "bayiidle")
            }
            
            let sequence = SKAction.sequence([moveRight, revertTextureAction])
            
            let walkForwardMoveAnimationGroup = SKAction.group([sequence, WalkingAnimationBaby.walkForwardAnimation(), revertTextureAction])
            
            bayi.run(walkForwardMoveAnimationGroup)
            
            box.run(moveRight)
            
            if bayi.position.x + moveDistance > size.width - bayi.size.width/2 ||
               box.position.x + moveDistance > size.width - box.size.width/2 {
                return
            }
        }
    }

    @objc private func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        let location = sender.location(in: view)
        let sceneLocation = convertPoint(fromView: location)
        
        if bebek.frame.contains(sceneLocation) {
            let flipAction = SKAction.scaleX(to: 1, duration: 0.5)
            bebek.run(flipAction)
        }
        
        if isBoxClicked {
            bayi.texture = SKTexture(imageNamed: "bayiidle")
            
            let moveDistance: CGFloat = -50.0
            let moveDuration: TimeInterval = 0.5
            
            let moveLeft = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)
            let revertTextureAction = SKAction.run {
                self.bayi.texture = SKTexture(imageNamed: "bayiidle")
            }
            
            let sequence = SKAction.sequence([moveLeft, revertTextureAction])
            bayi.run(sequence)
            
            box.run(moveLeft)
            
            if bayi.position.x + moveDistance < bayi.size.width/2 ||
               box.position.x + moveDistance < box.size.width/2 {
                return
            }
        }
    }
}
