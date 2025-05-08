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
    var isBabyMove : Bool = false
    //var newCameraPosition: CGPoint!
    var twoSideCameraCondition: Int = 1
    
    var invisibleWall: SKSpriteNode!
    
    
    let cameraNode = SKCameraNode()
    
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    
    override func update(_ currentTime: TimeInterval) {
        //cameraMovementUpdate()
        
    }
    
    func cameraMovementUpdateForBox(){
        
    }
    
    // kalo camnya ngikut bayi
//    func cameraMovementUpdate() {
//        let screenHalfWidth = scene!.size.width / 3
//        
//        let backgroundRightEdge = background.size.width
//        
//        let backgroundLeftEdge = background.position.x - background.size.width / 2
//        
//        let leftMax = backgroundLeftEdge + screenHalfWidth
//        
//        let rightMax = backgroundRightEdge - screenHalfWidth
//        print(rightMax)
//
//        if isBabyMove {
//            let lerpFactor: CGFloat = 0.1
//            let dx = bayi.position.x - cameraNode.position.x
//            let dy = bayi.position.y - cameraNode.position.y + 50
//            
//            // Predict next x position
//            var nextCameraX = cameraNode.position.x + dx * lerpFactor
//            //print(nextCameraX)
//            
//            //nextCameraX = min(max(nextCameraX, leftMax), rightMax)
//            if nextCameraX <= rightMax{
//                cameraNode.position.x = nextCameraX
//            }
//            else {
//                cameraNode.position.x = rightMax
//            }
//
//            cameraNode.position.x = nextCameraX
//                    cameraNode.position.y += dy * lerpFactor
//        }
//    }
    
    func cameraSetup(){
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        initialCameraPosition = cameraNode.position
        self.camera = cameraNode
        self.addChild(cameraNode)
    }
    
    // kalo zoom doang
//    func zoomCamera() {
//        if !isBabyMove{
//            let zoom = SKAction.scale(by: 0.7, duration: 2.0)
//            cameraNode.run(zoom)
//        }
//    }
    
    func zoomCamera() {
        let zoom = SKAction.scale(by: 0.8, duration: 2.0)
        let reSize = CGPoint(x: cameraNode.position.x + 50, y: cameraNode.position.y - 20)
        
        let cameraGroup = SKAction.group([zoom, SKAction.move(to: reSize, duration: 2.0)])
        if !isBabyMove{
            cameraNode.run(cameraGroup)
        }
    }
    
    func twoSideCamera() {
        let backgroundSizeWidth = background.size.width
        let backgroundSizeDevidedByFour = (background.size.width / 4)
        let leftSideMiddle = backgroundSizeDevidedByFour * (1 / 0.75)
        print(leftSideMiddle)
        let rightSideMiddle = backgroundSizeWidth - leftSideMiddle * (1 / 0.75)
        let hight = (background.size.height / 3)
        
        
        let zoomedInCameraPosition = CGPoint(x: leftSideMiddle, y: hight)
        let zoomedInScaledCamera = SKAction.scale(by: 0.75, duration: 2)
        
        if twoSideCameraCondition == 1 && !isBabyMove{
            cameraNode.run(zoomedInScaledCamera){
                self.cameraNode.run(SKAction.move(to: zoomedInCameraPosition, duration: 2))
            }
        }
        else{
        
        }
            
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
        pictureFrame2.position = CGPoint(x: size.width / 2 - 200, y: size.height * 0.75 - 100)
        pictureFrame2.zPosition = 0
        pictureFrame2.size = CGSize(width: 40, height: 40)
        pictureFrame2.name = "foto2"
        addChild(pictureFrame2)
    }
    
    func createBox(){
        box = SKSpriteNode(imageNamed: "boxGround")
        box.size = CGSize(width: 50, height: 60)
        box.position = CGPoint(x: size.width * 0.15 + 200, y: size.height * 0.11 + 50)
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
    
//    func createInvisibleWall(){
//        invisibleWall = SKSpriteNode(imageNamed: "boxGround")
//        invisibleWall.position = CGPoint(x: background.size.width / 4 + 100, y: background.size.height / 2)
//        invisibleWall.zPosition = 50
//        invisibleWall.size = size
//        addChild(invisibleWall)
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        
        for node in nodesAtPoint {
            //zoomCamera()
            twoSideCamera()
            if node.name?.contains("foto") == true{
                if node.name == "foto"{
                    let move = SKAction.move(to: CGPoint(x: pictureFrame.position.x, y: pictureFrame.position.y - 100), duration: 2)

                    
                    bayi.run(WalkingAnimationBaby.walkForwardAnimation(), withKey: "walk")
                    isBabyMove = true
                    bayi.run(move){
                       self.bayi.removeAction(forKey: "walk")
                        
                    }
                    bayi.run(WalkingAnimationBaby.delayAnimation()){
                        self.bayi.run(WalkingAnimationBaby.gapaiAnimation()){
                            self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
                        }
                    }
                }
                if node.name == "foto2"{
                    isBabyMove = true
                    let move = SKAction.move(to: CGPoint(x: pictureFrame2.position.x + 100, y: pictureFrame2.position.y - 100), duration: 2)

                    bayi.run(WalkingAnimationBaby.walkForwardAnimation(), withKey: "walk")
                    isBabyMove = true
                    bayi.run(move){
                       self.bayi.removeAction(forKey: "walk")
                        
                    }
                    bayi.run(WalkingAnimationBaby.delayAnimation()){
                        self.bayi.run(WalkingAnimationBaby.gapaiAnimation()){
                            self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
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
                           //zoomCamera(CGPoint: CGPoint(x: box.position.x + 300, y: box.position.y + 100))
                           isBabyMove = true
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
