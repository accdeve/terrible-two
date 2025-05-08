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
    private var box: SKSpriteNode!
    private var pictureFrame: SKSpriteNode!
    private var background: SKSpriteNode!
    
    private var isBoxClicked: Bool = false
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var movementTimer: Timer?
    private var isWalkingAnimationPlaying = false
    
    private var lastLeftMoveTime: Date?

    
    private let bayiBoxOffset: CGFloat = 60.0
    
    private enum MovementDirection {
        case left
        case right
    }
    
    private var currentMovementDirection: MovementDirection = .right

    override func didMove(to view: SKView) {
        size = view.bounds.size
        scaleMode = .aspectFill
        setupScene()
    }
    
    private func setupScene() {
        createBackground()
        createBaby()
        createBox()
        createBebek()
        createPictureFrame()
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
        bebek.position = CGPoint(x: size.width * 0.75, y: size.height * 0.15)
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
        box.zPosition = 2
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
            if node.name == "foto" {
                handlePictureFrameTouch()
                break
            } else if node.name == "bebekGround" {
                handleBebekTouch()
                break
            } else if node.name == "boxGround" {
                handleBoxTouch()
                break
            }
        }
    }
    
    private func handlePictureFrameTouch() {
        
        isBoxClicked = false
        box.color = isBoxClicked ? .red : .white
        
        let target = CGPoint(x: pictureFrame.position.x, y: pictureFrame.position.y - 200)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)
        
        let move = SKAction.move(to: target, duration: duration)
        let walkForwardMoveAnimationGroup = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])
                               
        bayi.run(walkForwardMoveAnimationGroup, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
        }
        bayi.run(WalkingAnimationBaby.delayAnimation()) {
            self.bayi.run(WalkingAnimationBaby.gapaiAnimation()) {
                self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
            }
        }
    }
    
    private func handleBebekTouch() {
        isBoxClicked = false
        box.color = isBoxClicked ? .red : .white

        let target = CGPoint(x: bebek.position.x - 50, y: bebek.position.y + 20)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, WalkingAnimationBaby.walkForwardAnimation()])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.bayi.texture = SKTexture(imageNamed: "babyidle")
        }
    }

    
    private func handleBoxTouch() {
        isBoxClicked.toggle()
        box.color = isBoxClicked ? .red : .white
        box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0
        
        if isBoxClicked {
            positionBabyNextToBox()
        }
    }
    
    private func positionBabyNextToBox() {
        // Calculate the proper position for the baby at the left side of the box
        let targetX = box.position.x - (box.size.width / 2) - bayiBoxOffset + 30
        let targetPosition = CGPoint(x: targetX, y: 80)
        
        let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)
        if distance > 10 {
            let moveDuration = min(3.0, distance / 100)
            let move = SKAction.move(to: targetPosition, duration: moveDuration)
            let walkAnimation = WalkingAnimationBaby.walkForwardAnimation()
            
            bayi.run(SKAction.group([move, walkAnimation]), withKey: "walk")
            bayi.run(move) {
                self.bayi.removeAction(forKey: "walk")
                self.bayi.texture = SKTexture(imageNamed: "babyidle")
            }
        }
    }
    
    private func addSwipeGestures() {
        
        if let panGesture = panGestureRecognizer {
            view?.removeGestureRecognizer(panGesture)
        }

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        if let panGesture = panGestureRecognizer {
            view?.addGestureRecognizer(panGesture)
        }
        
        movementTimer?.invalidate()
        movementTimer = nil
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        _ = convertPoint(fromView: location)
        let translation = sender.translation(in: view)
        
        let direction: MovementDirection = translation.x > 0 ? .right : .left
        
        if isBoxClicked {
            switch sender.state {
            case .began:
                currentMovementDirection = direction
                startContinuousMovement()
                
            case .changed:
                if direction != currentMovementDirection {
                    currentMovementDirection = direction
                    stopContinuousMovement()
                    startContinuousMovement()
                }
                
            case .ended, .cancelled, .failed:
                stopContinuousMovement()
                bayi.texture = SKTexture(imageNamed: "babyidle")
                
            default:
                break
            }
        }
    }

    private func startContinuousMovement() {
        guard movementTimer == nil else { return }

        let moveInterval: TimeInterval = 0.05

        movementTimer = Timer.scheduledTimer(withTimeInterval: moveInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let distance: CGFloat = self.currentMovementDirection == .right ? 5.0 : -10.0

            // Gerakan macet saat narik box
            if self.currentMovementDirection == .left {
                let now = Date()
                if let last = self.lastLeftMoveTime, now.timeIntervalSince(last) < 0.4 {
                    return
                }
                self.lastLeftMoveTime = now
            }

            // Batas kanan/kiri layar
            if self.currentMovementDirection == .right {
                if self.box.position.x + distance > self.size.width - self.box.size.width / 2 {
                    return
                }
            } else {
                if self.box.position.x + distance < self.box.size.width / 2 {
                    return
                }
            }

            // Gerakkan box
            let moveAction = SKAction.moveBy(x: distance, y: 0, duration: moveInterval)
            self.box.run(moveAction)

            self.updateBabyPosition()

            // Jalankan animasi kalau belum aktif
            if !self.isWalkingAnimationPlaying {
                self.isWalkingAnimationPlaying = true

                let walkAnimation = self.currentMovementDirection == .right
                    ? WalkingAnimationBaby.walkForwardAnimation()
                    : WalkingAnimationBaby.walkBackwardAnimation()

                self.bayi.run(SKAction.repeatForever(walkAnimation))
            }
        }
    }

    
    private func updateBabyPosition() {
        // Place baby to the left of the box at a fixed distance
        let targetX = box.position.x - (box.size.width / 2) - bayiBoxOffset + 30
        bayi.position.x = targetX
    }

    private func stopContinuousMovement() {
        movementTimer?.invalidate()
        movementTimer = nil
        
        if isWalkingAnimationPlaying {
            isWalkingAnimationPlaying = false
            bayi.removeAllActions()
            bayi.texture = SKTexture(imageNamed: "babyidle")
        }
    }
}
