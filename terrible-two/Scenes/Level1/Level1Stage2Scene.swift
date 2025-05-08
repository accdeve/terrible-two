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
    private var door: SKSpriteNode!

    private var isBoxClicked: Bool = false
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var movementTimer: Timer?
    private var isWalkingAnimationPlaying = false
    private var isBoxAtDoor: Bool = false
    private var isBabyMove: Bool = false

    private var hasCameraSequenceRun = false
    private var cameraNode: SKCameraNode!

    var isTeksDadIsComingActive = false
    var teksDadIsComing: SKLabelNode!

    private var lastLeftMoveTime: Date?
    private let bayiBoxOffset: CGFloat = 60.0
    private let kecepatanBayi: CGFloat = 100.0

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
    
    func cameraSetup(){
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        self.camera = cameraNode
        self.addChild(cameraNode)
    }
    
    func zoomCamera() {
        let zoom = SKAction.scale(by: 0.8, duration: 2.0)
        let reSize = CGPoint(x: cameraNode.position.x + 50, y: cameraNode.position.y - 20)

        let cameraGroup = SKAction.group([zoom, SKAction.move(to: reSize, duration: 2.0)])
        if !isBabyMove{
            cameraNode.run(cameraGroup)
                isBabyMove = true
            
            
        }
    }

    private func setupScene() {
        createBackground()
        createBaby()
        createBox()
        createBebek()
        createPictureFrame()
        createDoor()
        createCamera()
        createTeksDadIsComing()
        teksDadIsComingController()
    }

    func createBaby() {
        bayi = SKSpriteNode(imageNamed: "baby_sit")

        let targetWidth: CGFloat = 75.0

        let textureSize = bayi.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        bayi.setScale(scaleFactor)

        bayi.position = CGPoint(x: size.width * 0.25, y: size.height * 0.20)
        bayi.zPosition = 100
        bayi.name = "bayi"
        addChild(bayi)
    }

    func createBebek() {
        bebek = SKSpriteNode(imageNamed: "bebekGround")
        bebek.position = CGPoint(x: size.width * 0.75, y: size.height * 0.20)
        bebek.zPosition = 1
        bebek.name = "bebekGround"
        bebek.size = CGSize(width: 50, height: 40)
        addChild(bebek)
    }

    func createCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        if let cameraNode = cameraNode {
            addChild(cameraNode)
        }
        cameraNode?.setScale(1)
        cameraNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    func createPictureFrame() {
        pictureFrame = SKSpriteNode(imageNamed: "foto")
        pictureFrame.position = CGPoint(
            x: size.width / 2, y: size.height * 0.75)
        pictureFrame.zPosition = 0
        pictureFrame.size = CGSize(width: 40, height: 40)
        pictureFrame.name = "foto"
        addChild(pictureFrame)
    }

    func createBox() {
        box = SKSpriteNode(imageNamed: "boxGround")
        let targetWidth: CGFloat = 50.0

        let textureSize = box.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        box.setScale(scaleFactor)

        box.position = CGPoint(x: size.width * 0.40, y: size.height * 0.12)
        box.name = "boxGround"
        box.zPosition = 2
        addChild(box)
    }

    func createDoor() {
        door = SKSpriteNode(imageNamed: "foto")
        door.size = CGSize(width: 100, height: 200)  // Atur ukuran dulu
        door.position = CGPoint(
            x: size.width - door.size.width / 2,
            y: size.height - door.size.height)
        door.name = "doorGround"
        door.zPosition = 0
        addChild(door)
    }

    func createBackground() {
        background = SKSpriteNode(imageNamed: "level1_background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = size
        addChild(background)
    }

    func createTeksDadIsComing() {
        teksDadIsComing = SKLabelNode(fontNamed: "Chalkduster")
        teksDadIsComing.text = "Dad is coming"
        teksDadIsComing.fontColor = .black
        teksDadIsComing.fontSize = 100
        teksDadIsComing.position = CGPoint(
            x: size.width / 2, y: size.height / 2)
        teksDadIsComing.alpha = 0.0
        teksDadIsComing.zPosition = 100
        addChild(teksDadIsComing)
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

        let sequence = SKAction.sequence([
            blinkRepeat, deactivateFlag, hideText,
        ])
        teksDadIsComing.run(sequence)
    }

    func moveSceneIfFail() {
        let nextScene = Level1Stage1Scene()
        nextScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(nextScene, transition: transition)
    }

    func teksDadIsComingController() {
        let initialWait = SKAction.wait(forDuration: 5.0)
        let activateFlag = SKAction.run { [weak self] in
            self?.isTeksDadIsComingActive = true
            self?.showBlinkingText()
        }

        let waitBetweenRepeats = SKAction.wait(forDuration: 10.0)
        let sequence = SKAction.sequence([
            initialWait, activateFlag, waitBetweenRepeats,
        ])
        let repeatAction = SKAction.repeatForever(sequence)

        run(repeatAction, withKey: "teksDadIsComingController")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            zoomCamera()
            if node.name == "foto" {
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handlePictureFrameTouch()
                    break
                }
            } else if node.name == "bebekGround" {
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleBebekTouch()
                    break
                }
            } else if node.name == "boxGround" {
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleBoxTouch()
                    break
                }
            } else if node.name == "doorGround" {
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleDoorTouch()
                    break
                }
            }
        }
    }

    private func handleDoorTouch() {
        isBoxClicked = false
        box.color = .white
        self.setSwipeGesture(enabled: false)

        let target = CGPoint(x: door.position.x - 20, y: door.position.y - 90)
        let distance = hypot(
            bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([
            move, WalkingAnimationBaby.walkForwardAnimation(),
        ])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")

            if self.isBoxAtDoor {
                print("Box sudah di pintu, bayi bisa naik dan buka pintu.")

                // Animasi lompat
                self.jumpAnimation()
            } else {
                print("Box belum di pintu, bayi ngambek.")
                // Animasi gapai
                self.jumpAnimation()
            }
        }
    }

    private func jumpAnimation() {
        let jumpFrames = [
            SKTexture(imageNamed: "baby_jumping1"),
            SKTexture(imageNamed: "baby_jumping2"),
        ]

        let jumpAction = SKAction.animate(with: jumpFrames, timePerFrame: 0.3)
        let jumpRepeat = SKAction.repeat(jumpAction, count: 4)

        let jumpGroup = SKAction.group([jumpRepeat])

        bayi.run(jumpGroup) {
            self.bayi.texture = SKTexture(imageNamed: "baby_sit")
        }
    }

    private func handlePictureFrameTouch() {

        isBoxClicked = false
        self.setSwipeGesture(enabled: false)
        box.color = .white

        let target = CGPoint(
            x: pictureFrame.position.x, y: pictureFrame.position.y - 200)
        let distance = hypot(
            bayi.position.x - target.x, bayi.position.y - target.y)

        let duration = TimeInterval(distance / kecepatanBayi)

        let move = SKAction.move(to: target, duration: duration)

        let walkAnimation: SKAction
        if target.x > bayi.position.x {
            walkAnimation = WalkingAnimationBaby.walkForwardAnimation()
        } else {
            walkAnimation = WalkingAnimationBaby.walkBackwardAnimation()
        }

        let walkAnimationGroup = SKAction.group([move, walkAnimation])

        bayi.run(walkAnimationGroup, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.jumpAnimation()
        }
    }

    private func handleBebekTouch() {

        self.setSwipeGesture(enabled: false)
        isBoxClicked = false
        box.color = .white

        let target = CGPoint(x: bebek.position.x - 50, y: bebek.position.y + 30)
        let distance = hypot(
            bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let animation: SKAction =
            target.x > bayi.position.x
            ? WalkingAnimationBaby.walkForwardAnimation()
            : WalkingAnimationBaby.walkBackwardAnimation()

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, animation])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.bayi.texture = SKTexture(imageNamed: "baby_sit")
        }
    }

    private func handleBoxTouch() {
        isBoxClicked.toggle()
        box.color = isBoxClicked ? .red : .white
        box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0

        if isBoxClicked {
            positionBabyNextToBox()
            if !hasCameraSequenceRun {
                hasCameraSequenceRun = true
                isBabyMove = false
                if let cameraNode = cameraNode {
                    let zoomIn = SKAction.scale(to: 0.5, duration: 1.0)
                    let moveToBayi = SKAction.move(
                        to: CGPoint(
                            x: box.position.x, y: box.position.y + 100),
                        duration: 1.0)
                    let bayiFollowGroup = SKAction.group([zoomIn, moveToBayi])

                    let wait1 = SKAction.wait(forDuration: 1.0)
                    let moveToDoor = SKAction.move(
                        to: CGPoint(x: size.width / 1.35, y: size.height / 2),
                        duration: 1.0)
                    let wait2 = SKAction.wait(forDuration: 1.0)
                    let zoomOut = SKAction.scale(to: 1.0, duration: 1.0)
                    let moveToCenter = SKAction.move(
                        to: CGPoint(x: size.width / 2, y: size.height / 2),
                        duration: 1.0)
                    let zoomOutGroup = SKAction.group([zoomOut, moveToCenter])

                    let sequence = SKAction.sequence([
                        bayiFollowGroup,
                        wait1,
                        moveToDoor,
                        wait2,
                        zoomOutGroup,
                    ])

                    cameraNode.run(sequence){
                        self.zoomCamera()
                    }
                    
                    
                }
            }

        }
    }

    private func positionBabyNextToBox() {
        let targetX = box.position.x - (box.size.width / 2) - bayiBoxOffset + 30
        let targetPosition = CGPoint(x: targetX, y: 80)

        let distance = hypot(
            bayi.position.x - targetPosition.x,
            bayi.position.y - targetPosition.y)
        if distance > 10 {

            let kecepatanBayi: CGFloat = 130.0
            let duration = TimeInterval(distance / kecepatanBayi)

            let move = SKAction.move(to: targetPosition, duration: duration)

            let walkAnimation: SKAction
            if targetPosition.x > bayi.position.x {
                walkAnimation = WalkingAnimationBaby.walkForwardAnimation()
            } else {
                walkAnimation = WalkingAnimationBaby.walkBackwardAnimation()
            }

            bayi.run(SKAction.group([move, walkAnimation]), withKey: "walk")

            bayi.run(move) {
                self.bayi.removeAction(forKey: "walk")
                self.bayi.texture = SKTexture(imageNamed: "baby_sit")
                self.enableSwipeAfterBoxAnimation()
            }
        } else {
            self.enableSwipeAfterBoxAnimation()
        }
    }

    private func addSwipeGestures() {

        if let panGesture = panGestureRecognizer {
            view?.removeGestureRecognizer(panGesture)
        }

        panGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(handlePanGesture))
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
                bayi.texture = SKTexture(imageNamed: "baby_sit")

            default:
                break
            }
        }
    }

    private func startContinuousMovement() {
        guard movementTimer == nil else { return }

        let moveInterval: TimeInterval = 0.05

        movementTimer = Timer.scheduledTimer(
            withTimeInterval: moveInterval, repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }

            let distance: CGFloat =
                self.currentMovementDirection == .right ? 5.0 : -10.0

            // Gerakan macet saat narik box
            if self.currentMovementDirection == .left {
                let now = Date()
                if let last = self.lastLeftMoveTime,
                    now.timeIntervalSince(last) < 0.4
                {
                    return
                }
                self.lastLeftMoveTime = now
            }

            // Batas kanan/kiri layar
            if self.currentMovementDirection == .right {
                if self.box.position.x + distance > self.size.width
                    - (self.box.size.width / 2) - 20
                {
                    return
                }
            } else {
                if self.box.position.x + distance < self.box.size.width / 2 + 50
                {
                    return
                }
            }

            // Gerakkan box
            let moveAction = SKAction.moveBy(
                x: distance, y: 0, duration: moveInterval)
            self.box.run(moveAction)

            self.updateBabyPosition()

            let predictedBoxX = self.box.position.x + distance
            let batasKanan = self.size.width - (self.box.size.width / 2) - 25
            self.isBoxAtDoor = predictedBoxX >= batasKanan
            // print("Box Posisi X:", box.position.x, " | Batas Kanan:", batasKanan, " | isBoxAtDoor:", isBoxAtDoor)

            // Jalankan animasi kalau belum aktif
            if !self.isWalkingAnimationPlaying {
                self.isWalkingAnimationPlaying = true

                let walkAnimation =
                    self.currentMovementDirection == .right
                    ? WalkingAnimationBaby.walkLowRight()
                    : WalkingAnimationBaby.walkLowRightBackward()

                self.bayi.run(SKAction.repeatForever(walkAnimation))
            }
        }
    }

    private func updateBabyPosition() {
        let targetX = box.position.x - (box.size.width / 2) - bayiBoxOffset + 30
        bayi.position.x = targetX
    }

    private func stopContinuousMovement() {
        movementTimer?.invalidate()
        movementTimer = nil

        if isWalkingAnimationPlaying {
            isWalkingAnimationPlaying = false
            bayi.removeAllActions()
            bayi.texture = SKTexture(imageNamed: "baby_sit")
        }
    }

    private func enableSwipeAfterBoxAnimation() {
        // Hindari duplikat gesture
        if let pan = panGestureRecognizer {
            view?.removeGestureRecognizer(pan)
        }
        addSwipeGestures()
    }

    private func setSwipeGesture(enabled: Bool) {
        if enabled {
            // Tambahkan jika belum ada
            if panGestureRecognizer == nil {
                let pan = UIPanGestureRecognizer(
                    target: self, action: #selector(handlePanGesture))
                panGestureRecognizer = pan
                view?.addGestureRecognizer(pan)
            }
        } else {
            // Hapus jika ada
            if let pan = panGestureRecognizer {
                view?.removeGestureRecognizer(pan)
                panGestureRecognizer = nil
            }
        }
    }

}
