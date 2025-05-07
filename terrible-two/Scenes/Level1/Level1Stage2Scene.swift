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
    var pictureFrame: SKSpriteNode!
    var pictureFrame2: SKSpriteNode!
    var background: SKSpriteNode!
    var initialCameraPosition: CGPoint!
    var isBoxClicked : Bool = false
    var isBabyMove : Int = 1
    
    let cameraNode = SKCameraNode()
    
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    
    override func update(_ currentTime: TimeInterval) {
        if isBabyMove == 2{
            let lerpFactor: CGFloat = 0.1
            let dx = bayi.position.x - cameraNode.position.x
            let dy = bayi.position.y - cameraNode.position.y
            cameraNode.position.x += dx * lerpFactor
            cameraNode.position.y += dy * lerpFactor
            }
    }
    
    func stopCamera() {
        //cameraNode.removeAllActions()
        let zoomOut = SKAction.scale(to: 1.0, duration: 2)
        let moveBack = SKAction.move(to: initialCameraPosition, duration: 2)
        let cameraGroup = SKAction.group([zoomOut, moveBack])

        cameraNode.run(cameraGroup){
            self.isBabyMove = 1
            print(self.isBabyMove)
        }
    }
    
    func cameraSetup(){
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        initialCameraPosition = cameraNode.position
        self.camera = cameraNode
        self.addChild(cameraNode)
    }
    
    func moveCamera() {
        cameraNode.removeAllActions()
        let zoom = SKAction.scale(by: 0.8, duration: 2.0)
        cameraNode.run(zoom)
    }
    
    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .aspectFill
        cameraSetup()
        createBackground()
        createBaby()
        createBox()
        createBebek()
        createPictureFrame()
        createPictureFrame2()
        addSwipeGestures()
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
        pictureFrame.position = CGPoint(x: size.width / 2 + 200, y: size.height * 0.75 - 100)
        pictureFrame.zPosition = 0
        pictureFrame.size = CGSize(width: 40, height: 40)
        pictureFrame.name = "foto"
        addChild(pictureFrame)
    }
    
    func createPictureFrame2(){
        pictureFrame2 = SKSpriteNode(imageNamed: "foto")
        pictureFrame2.position = CGPoint(x: size.width / 2, y: size.height * 0.75 - 100)
        pictureFrame2.zPosition = 0
        pictureFrame2.size = CGSize(width: 40, height: 40)
        pictureFrame2.name = "foto2"
        addChild(pictureFrame2)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        
        for node in nodesAtPoint {
            if node.name?.contains("foto") == true{
                if node.name == "foto" && isBabyMove != 2{
                    isBabyMove = 2
                    moveCamera()
                    let move = SKAction.move(to: CGPoint(x: pictureFrame.position.x, y: pictureFrame.position.y - 100), duration: 2)

                    bayi.run(WalkingAnimationBaby.walkForwardAnimation(), withKey: "walk")
                    bayi.run(move){
                       self.bayi.removeAction(forKey: "walk")
                        
                    }
                    bayi.run(WalkingAnimationBaby.delayAnimation()){
                        self.bayi.run(WalkingAnimationBaby.gapaiAnimation()){
                            self.bayi.run(WalkingAnimationBaby.ngambekAnimation()){
                                self.stopCamera()
                            }
                        }
                    }
                }
                if node.name == "foto2" && isBabyMove != 2{
                    isBabyMove = 2
                    moveCamera()
                    let move = SKAction.move(to: CGPoint(x: pictureFrame2.position.x, y: pictureFrame2.position.y - 100), duration: 2)

                    bayi.run(WalkingAnimationBaby.walkForwardAnimation(), withKey: "walk")
                    bayi.run(move){
                       self.bayi.removeAction(forKey: "walk")
                        
                    }
                    bayi.run(WalkingAnimationBaby.delayAnimation()){
                        self.bayi.run(WalkingAnimationBaby.gapaiAnimation()){
                            self.bayi.run(WalkingAnimationBaby.ngambekAnimation()){
                                self.stopCamera()
                            }
                        }
                    }
                }
            }
            else if node.name?.contains("Ground") == true{
                if node.name == "bebekGround" {
                   let move = SKAction.move(to: CGPoint(x: bebek.position.x - 20, y: bebek.position.y), duration: 2)
                   let walkForwardMoveAnimationGroup = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                                      
                   bayi.run(walkForwardMoveAnimationGroup, withKey: "walk")
                   bayi.run(move){
                      self.bayi.removeAction(forKey: "walk")
                   }
                   break
               } else if node.name == "boxGround" {
                   isBoxClicked.toggle()
                   box.color = isBoxClicked ? .red : .white
                   box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0
                   
                   if isBoxClicked {
                       let boxLeftEdge = box.position.x - (box.size.width / 2) - (bayi.size.width / 2) - 10
                       let targetPosition = CGPoint(x: boxLeftEdge, y: box.position.y)

                       let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)
                       if distance > 20 {
                           let move = SKAction.move(to: CGPoint(x: box.position.x - 20, y: box.position.y), duration: 2)
                           _ = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                                
                           _ = SKAction.run {
                               self.bayi.texture = SKTexture(imageNamed: "bayiidle")
                           }
                           bayi.run(move){
                              self.bayi.removeAction(forKey: "walk")
                           }
                       }
                   }
                   break
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
