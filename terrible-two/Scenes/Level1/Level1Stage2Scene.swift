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
    private var car: SKSpriteNode!
    private var teddyBear: SKSpriteNode!
    private var bunnyDoll: SKSpriteNode!
    private var ball: SKSpriteNode!

    private var isBoxClicked: Bool = false
    private var swipeRightRecognizer: UISwipeGestureRecognizer?
    private var swipeLeftRecognizer: UISwipeGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var movementTimer: Timer?
    private var isWalkingAnimationPlaying = false
    private var isBoxAtDoor: Bool = false
    private var isBabyMove: Bool = false
    private var isInteracting: Bool = false

    private var hasCameraSequenceRun = false
    private var cameraNode: SKCameraNode!

    var hintContainer = SKNode()
    var isTeksDadIsComingActive = false
    var teksDadIsComing: SKLabelNode!

    private var lastLeftMoveTime: Date?
    private let bayiBoxOffset: CGFloat = 60.0
    private let kecepatanBayi: CGFloat = 100.0
    private let babyTargetWidth: CGFloat = 120

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

    func cameraSetup() {
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        self.camera = cameraNode
        self.addChild(cameraNode)
    }

    func zoomCamera() {
        let zoom = SKAction.scale(by: 0.8, duration: 2.0)
        let reSize = CGPoint(
            x: cameraNode.position.x + 80, y: cameraNode.position.y - 20)

        let cameraGroup = SKAction.group([
            zoom, SKAction.move(to: reSize, duration: 2.0),
        ])
        if !isBabyMove {
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
        createCar()
        createBunnyDoll()
        createTeddyBear()
        createTeksDadIsComing()
        teksDadIsComingController()
    }

    func createBaby() {
        bayi = SKSpriteNode(imageNamed: "baby_idle_stand")

        let textureSize = bayi.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = babyTargetWidth / textureSize.width
        bayi.setScale(scaleFactor)

        bayi.position = CGPoint(x: size.width * 0.25,  y: size.height * 0.20)
        bayi.zPosition = 100
        bayi.name = "bayi"
        addChild(bayi)
    }

    func createBebek() {
        bebek = SKSpriteNode(imageNamed: "bebekGround")

        let targetWidth: CGFloat = 50.0

        let textureSize = bebek.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        bebek.setScale(scaleFactor)

        bebek.position = CGPoint(x: size.width * 0.78, y: size.height * 0.10)
        bebek.zPosition = 101
        bebek.name = "bebekGround"

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

        let targetWidth: CGFloat = 75.0

        let textureSize =
            pictureFrame.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        pictureFrame.setScale(scaleFactor)

        pictureFrame.position = CGPoint(
            x: size.width / 2 + 100, y: size.height * 0.75 - 40)
        pictureFrame.zPosition = 0
        pictureFrame.name = "foto"
        addChild(pictureFrame)
    }

    func createBox() {
        box = SKSpriteNode(imageNamed: "boxGround")
        let targetWidth: CGFloat = 50.0

        let textureSize = box.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        box.setScale(scaleFactor)

        box.position = CGPoint(x: size.width * 0.53, y: size.height * 0.18)
        box.name = "boxGround"
        box.zPosition = 2
        addChild(box)
    }

    func createDoor() {
        door = SKSpriteNode(imageNamed: "level1_door_closed")
        let targetWidth: CGFloat = 76.0

        let textureSize = door.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        door.setScale(scaleFactor)

        door.position = CGPoint(
            x: size.width - door.size.width / 2,
            y: size.height - door.size.height + 30)
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
    
    func createCar() {
        car = SKSpriteNode(imageNamed: "car")

        let targetWidth: CGFloat = 50.0

        let textureSize = car.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        car.setScale(scaleFactor)

        car.position = CGPoint(x: size.width * 0.65, y: size.height * 0.10 - 10)
        car.zPosition = 101
        car.name = "car"

        addChild(car)
    }
    
    func createTeddyBear() {
        teddyBear = SKSpriteNode(imageNamed: "teddy_bear")

        let targetWidth: CGFloat = 50.0

        let textureSize = teddyBear.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        teddyBear.setScale(scaleFactor)

        teddyBear.position = CGPoint(x: size.width * 0.40, y: size.height * 0.10 + 20)
        teddyBear.zPosition = 99
        teddyBear.name = "teddyBear"

        addChild(teddyBear)
    }
    
    func createBunnyDoll() {
        bunnyDoll = SKSpriteNode(imageNamed: "bunny_doll")

        let targetWidth: CGFloat = 45.0

        let textureSize = bunnyDoll.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        bunnyDoll.setScale(scaleFactor)

        bunnyDoll.position = CGPoint(x: size.width * 0.35, y: size.height * 0.12 + 20)
        bunnyDoll.zPosition = 99
        bunnyDoll.name = "bunnyDoll"

        addChild(bunnyDoll)
    }

    func createTeksDadIsComing() {
        hintContainer.name = "hint"
        hintContainer.position = CGPoint(
            x: size.width / 1.71,
            y: size.height * 0.75)
        hintContainer.zPosition = 100
        hintContainer.alpha = 0.0

        let background = SKShapeNode(
            rectOf: CGSize(width: size.width * 0.6, height: size.height * 0.125),
            cornerRadius: 16)
        background.fillColor = SKColor.black.withAlphaComponent(0.6)
        background.strokeColor = SKColor.white.withAlphaComponent(0.8)
        background.lineWidth = 1
        background.alpha = 0.9
        hintContainer.addChild(background)

        teksDadIsComing = SKLabelNode(fontNamed: "Chalkduster")
        teksDadIsComing.text = "Dad is coming ‼️"
        teksDadIsComing.fontColor = .white
        teksDadIsComing.fontSize = 25
        teksDadIsComing.position = CGPoint(x: 0, y: -10)
        teksDadIsComing.alpha = 0.0
        teksDadIsComing.zPosition = 101

        hintContainer.addChild(teksDadIsComing)

        addChild(hintContainer)
        }

    func showBlinkingText() {
        teksDadIsComing.alpha = 0.0

        let blinkOn = SKAction.fadeAlpha(to: 0.0, duration: 0.7)
        let blinkOff = SKAction.fadeAlpha(to: 1.0, duration: 0.7)
        let blink = SKAction.sequence([blinkOff, blinkOn])
        let blinkRepeat = SKAction.repeat(blink, count: 5)

        let deactivateFlag = SKAction.run { [weak self] in
            self?.isTeksDadIsComingActive = false
        }

        let hideText = SKAction.run { [weak self] in
            self?.teksDadIsComing.alpha = 0.0
            self?.hintContainer.alpha = 0.0
        }

        let sequence = SKAction.sequence([
            blinkRepeat, deactivateFlag, hideText,
        ])
        hintContainer.run(sequence)
        teksDadIsComing.run(sequence)
    }

    func moveSceneIfFail() {
        let nextScene = Level1Stage1Scene(size: self.size)
        let transition = SKTransition.fade(withDuration: 1.5)
        self.view?.presentScene(nextScene, transition: transition)
    }

    func teksDadIsComingController() {
        let initialWait = SKAction.wait(forDuration: 5.0)
        let activateFlag = SKAction.run { [weak self] in
            SKAction.wait(forDuration: 60.0)
            self?.showBlinkingText()
            self?.isTeksDadIsComingActive = true
        }

        let waitBetweenRepeats = SKAction.wait(forDuration: 60.0)
        let sequence = SKAction.sequence([
            initialWait, activateFlag, waitBetweenRepeats,
        ])
        let repeatAction = SKAction.repeatForever(sequence)

        run(repeatAction, withKey: "teksDadIsComingController")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isInteracting else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "foto" {
                zoomCamera()
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handlePictureFrameTouch()
                    break
                }
            } else if node.name == "bebekGround" {
                zoomCamera()
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleBebekTouch()
                    break
                }
            } else if node.name == "car" {
                zoomCamera()
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleCarTouch()
                    break
                }
            } else if node.name == "teddyBear" {
                zoomCamera()
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleTeddBearTouch()
                    break
                }
            } else if node.name == "bunnyDoll" {
                zoomCamera()
                isBabyMove = true
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleBunnyDollTouch()
                    break
                }
            } else if node.name == "boxGround" {
                if isTeksDadIsComingActive {
                    moveSceneIfFail()
                } else {
                    handleBoxTouch()
                    break
                }
            } else if node.name == "doorGround" {
                zoomCamera()
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

    private func jumpAnimation() {
        let jumpFrames = [
            SKTexture(imageNamed: "baby_jumping1"),
            SKTexture(imageNamed: "baby_jumping2")
        ]

        let jumpActions = jumpFrames.flatMap { texture in
            [
                SKAction.run { self.setBabyTexture(texture) },
                SKAction.wait(forDuration: 0.3)
            ]
        }

        let jumpSequence = SKAction.sequence(jumpActions)
        let repeatJump = SKAction.repeat(jumpSequence, count: 4)

        let resetIdle = SKAction.run {
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))
            self.isInteracting = false
        }

        let full = SKAction.sequence([repeatJump, resetIdle])
        bayi.run(full)
    }
    
    private func openDoorAnimation() {
        let frames = (1...5).map {
            SKTexture(imageNamed: "baby_open_door\($0)")
        }

        let actions: [SKAction] = frames.enumerated().map { (index, texture) in
            var frameActions: [SKAction] = [
                SKAction.run { self.setBabyTexture(texture) }
            ]

            if index >= 2 {
                let naikSedikit = SKAction.moveBy(x: 0, y: 20, duration: 0.2)
                frameActions.append(naikSedikit)
            }

            frameActions.append(SKAction.wait(forDuration: 0.2))

            return SKAction.sequence(frameActions)
        }

        let openDoorTexture = SKTexture(imageNamed: "level1_door_open")
        let openDoorAction = SKAction.run {
            self.door.texture = openDoorTexture
            let scale = 76.0 / openDoorTexture.size().width
            self.door.size = CGSize(width: 76.0, height: openDoorTexture.size().height * scale)
        }

        let fullSequence = SKAction.sequence(actions + [openDoorAction])
        bayi.run(fullSequence)
    }
    
    private func playWithBebekAnimation() {
        let tiltLeft = SKAction.rotate(toAngle: CGFloat(-0.1), duration: 0.1)
        let tiltRight = SKAction.rotate(toAngle: CGFloat(0.1), duration: 0.1)
        let reset = SKAction.rotate(toAngle: 0.0, duration: 0.1)

        let wiggle = SKAction.sequence([
            tiltLeft, tiltRight, tiltLeft, tiltRight, reset
        ])

        let bounceUp = SKAction.moveBy(x: 0, y: 10, duration: 0.1)
        let bounceDown = SKAction.moveBy(x: 0, y: -10, duration: 0.1)
        let bounce = SKAction.sequence([bounceUp, bounceDown])

        let playSequence = SKAction.group([wiggle, bounce])
        let repeatPlay = SKAction.repeat(playSequence, count: 3)

        let finishInteraction = SKAction.run {
            self.isInteracting = false
        }

        let fullSequence = SKAction.sequence([repeatPlay, finishInteraction])
        bebek.run(fullSequence)
    }
    
    private func playWithCarAnimation() {
        let tiltLeft = SKAction.rotate(toAngle: CGFloat(-0.05), duration: 0.2)
        let tiltRight = SKAction.rotate(toAngle: CGFloat(0.05), duration: 0.2)
        let resetTilt = SKAction.rotate(toAngle: 0.0, duration: 0.1)
        let tiltSequence = SKAction.sequence([tiltLeft, tiltRight, tiltLeft, tiltRight, resetTilt])

        let moveForward = SKAction.moveBy(x: 15, y: 0, duration: 0.2)
        let moveBackward = SKAction.moveBy(x: -15, y: 0, duration: 0.2)
        let moveSequence = SKAction.sequence([moveForward, moveBackward])

        let playSequence = SKAction.group([tiltSequence, moveSequence])
        let repeatPlay = SKAction.repeat(playSequence, count: 3)

        let finishInteraction = SKAction.run {
            self.isInteracting = false
        }

        let fullSequence = SKAction.sequence([repeatPlay, finishInteraction])
        car.run(fullSequence)
    }
    
    private func playWithTeddyBearAnimation() {

        let tiltLeft = SKAction.rotate(toAngle: CGFloat(-0.08), duration: 0.3)
        let tiltRight = SKAction.rotate(toAngle: CGFloat(0.08), duration: 0.3)
        let resetTilt = SKAction.rotate(toAngle: 0.0, duration: 0.2)
        let tiltSequence = SKAction.sequence([
            tiltLeft, tiltRight, tiltLeft, tiltRight, resetTilt
        ])
        
        let moveUp = SKAction.moveBy(x: 0, y: 8, duration: 0.3)
        let moveDown = SKAction.moveBy(x: 0, y: -8, duration: 0.3)
        let bounceSequence = SKAction.sequence([moveUp, moveDown])

        let playSequence = SKAction.group([tiltSequence, bounceSequence])
        let repeatPlay = SKAction.repeat(playSequence, count: 1)

        let finishInteraction = SKAction.run {
            self.isInteracting = false
        }

        let fullSequence = SKAction.sequence([repeatPlay, finishInteraction])
        teddyBear.run(fullSequence)
    }
    
    private func playWithBunnyDollAnimation() {

        let tiltLeft = SKAction.rotate(toAngle: CGFloat(-0.08), duration: 0.3)
        let tiltRight = SKAction.rotate(toAngle: CGFloat(0.08), duration: 0.3)
        let resetTilt = SKAction.rotate(toAngle: 0.0, duration: 0.2)
        let tiltSequence = SKAction.sequence([
            tiltLeft, tiltRight, tiltLeft, tiltRight, resetTilt
        ])
        
        let moveUp = SKAction.moveBy(x: 0, y: 8, duration: 0.3)
        let moveDown = SKAction.moveBy(x: 0, y: -8, duration: 0.3)
        let bounceSequence = SKAction.sequence([moveUp, moveDown])

        let playSequence = SKAction.group([tiltSequence, bounceSequence])
        let repeatPlay = SKAction.repeat(playSequence, count: 1)

        let finishInteraction = SKAction.run {
            self.isInteracting = false
        }

        let fullSequence = SKAction.sequence([repeatPlay, finishInteraction])
        bunnyDoll.run(fullSequence)
    }

    private func handleDoorTouch() {
        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        isBoxClicked = false
        box.color = .white
        self.setSwipeGesture(enabled: false)

        let target = CGPoint(x: door.position.x - 20, y: door.position.y - 90)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([
            move, WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture),
        ])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))

            if self.isBoxAtDoor {
                print("Box sudah di pintu, bayi bisa naik dan buka pintu.")
                self.openDoorAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.transitionToNextScene()
                }
            } else {
                print("Box belum di pintu, bayi ngambek.")
                self.jumpAnimation()
            }
        }
    }

    private func handlePictureFrameTouch() {

        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        isBoxClicked = false
        self.setSwipeGesture(enabled: false)
        box.color = .white

        let target = CGPoint(
            x: pictureFrame.position.x, y: pictureFrame.position.y - 170)
        let distance = hypot(
            bayi.position.x - target.x, bayi.position.y - target.y)

        let duration = TimeInterval(distance / kecepatanBayi)

        let move = SKAction.move(to: target, duration: duration)

        let walkAnimation: SKAction
        if target.x > bayi.position.x {
            walkAnimation = WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
        } else {
            walkAnimation = WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)
        }

        let walkAnimationGroup = SKAction.group([move, walkAnimation])

        bayi.run(walkAnimationGroup, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))
            self.jumpAnimation()
        }
    }

    private func handleBebekTouch() {
        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        self.setSwipeGesture(enabled: false)
        isBoxClicked = false
        box.color = .white

        let target = CGPoint(x: bebek.position.x - 50, y: bebek.position.y + 30)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let animation: SKAction =
            target.x > bayi.position.x
            ? WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
            : WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, animation])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_sit"))
        
            self.playWithBebekAnimation()
        }
    }
    
    private func handleCarTouch() {
        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        self.setSwipeGesture(enabled: false)
        isBoxClicked = false
        box.color = .white

        let target = CGPoint(x: car.position.x - 50, y: car.position.y + 30)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let animation: SKAction =
            target.x > bayi.position.x
            ? WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
            : WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, animation])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_sit"))
        
            self.playWithCarAnimation()
        }
    }
    
    private func handleTeddBearTouch() {
        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        self.setSwipeGesture(enabled: false)
        isBoxClicked = false
        box.color = .white

        let target = CGPoint(x: teddyBear.position.x + 50, y: teddyBear.position.y + 10)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let animation: SKAction =
            target.x > bayi.position.x
            ? WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
            : WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, animation])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
        
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_sit_flip"))

            self.playWithTeddyBearAnimation()
        }
    }
    
    private func handleBunnyDollTouch() {
        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        self.setSwipeGesture(enabled: false)
        isBoxClicked = false
        box.color = .white

        let target = CGPoint(x: bunnyDoll.position.x - 55, y: bunnyDoll.position.y)
        let distance = hypot(bayi.position.x - target.x, bayi.position.y - target.y)
        let kecepatanBayi: CGFloat = 130.0
        let duration = TimeInterval(distance / kecepatanBayi)

        let animation: SKAction =
            target.x > bayi.position.x
            ? WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
            : WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)

        let move = SKAction.move(to: target, duration: duration)
        let walk = SKAction.group([move, animation])

        bayi.run(walk, withKey: "walk")
        bayi.run(move) {
            self.bayi.removeAction(forKey: "walk")
            self.setBabyTexture(SKTexture(imageNamed: "baby_idle_sit"))
        
            self.playWithBunnyDollAnimation()
        }
    }

    private func handleBoxTouch() {

        guard !isInteracting else { return }
        stopAllCurrentActions()
        isInteracting = true

        isBoxClicked.toggle()
        box.color = isBoxClicked ? .red : .white
        box.colorBlendFactor = isBoxClicked ? 0.5 : 0.0

        if isBoxClicked {
            positionBabyNextToBox()
            if !hasCameraSequenceRun {
                hasCameraSequenceRun = true
                isBabyMove = false
                if let cameraNode = cameraNode {
                    let zoomIn = SKAction.scale(to: 0.5, duration: 2.0)
                    let moveToBayi = SKAction.move(
                        to: CGPoint(
                            x: box.position.x, y: box.position.y + 76),
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

                    cameraNode.run(sequence) {
                        self.zoomCamera()
                    }

                }
            }
        }
        self.isInteracting = false
    }

    private func positionBabyNextToBox() {
        let offset: CGFloat = bayiBoxOffset - 30

        let targetX: CGFloat
        if currentMovementDirection == .right {
            targetX = box.position.x - (box.size.width / 2) - offset
        } else {
            targetX = box.position.x + (box.size.width / 2) + offset
        }

        let targetPosition = CGPoint(x: targetX, y: 90)
        let distance = hypot(bayi.position.x - targetPosition.x, bayi.position.y - targetPosition.y)

        if distance > 10 {
            let duration = TimeInterval(distance / 130.0)

            let move = SKAction.move(to: targetPosition, duration: duration)
            let walkAnimation = targetX > bayi.position.x
                ? WalkingAnimationBaby.walkForwardAnimation(using: self.setBabyTexture)
                : WalkingAnimationBaby.walkBackwardAnimation(using: self.setBabyTexture)

            bayi.run(SKAction.group([move, walkAnimation]), withKey: "walk")
            bayi.run(move) {
                self.bayi.removeAction(forKey: "walk")
                self.setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))
                self.enableSwipeAfterBoxAnimation()
                self.isInteracting = false
            }
        } else {
            self.enableSwipeAfterBoxAnimation()
            self.isInteracting = false
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
                bayi.texture = SKTexture(imageNamed: "baby_idle_stand")

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

            let distance: CGFloat = self.currentMovementDirection == .right ? 5.0 : -5.0

            // Batas kanan/kiri layar
            let boxPosX = self.box.position.x + distance
            if self.currentMovementDirection == .right {
                let batasKanan = self.size.width - (self.box.size.width / 2) - 20
                if boxPosX > batasKanan { return }
            } else {
                let batasKiri = self.box.size.width / 2 + 420
                if boxPosX < batasKiri { return }
            }

            // Gerakkan box
            let moveAction = SKAction.moveBy(x: distance, y: 0, duration: moveInterval)
            self.box.run(moveAction)

            self.updateBabyPosition()

            // Cek apakah box sampai di depan pintu
            let predictedBoxX = self.box.position.x + distance
            let batasPintu = self.size.width - (self.box.size.width / 2) - 25
            self.isBoxAtDoor = predictedBoxX >= batasPintu

            // Mulai animasi jalan
            if !self.isWalkingAnimationPlaying {
                self.isWalkingAnimationPlaying = true

                let walkAnim: SKAction
                if self.currentMovementDirection == .right {
                    walkAnim = WalkingAnimationBaby.walkLowRight(using: self.setBabyTexture)
                } else {
                    walkAnim = WalkingAnimationBaby.walkLowRightBackward(using: self.setBabyTexture)
                }

                let repeatAnim = SKAction.repeatForever(walkAnim)
                self.bayi.run(repeatAnim, withKey: "walk")
            }
        }
    }

    private func updateBabyPosition() {
        let offset: CGFloat = bayiBoxOffset - 30

        let targetX: CGFloat
        if currentMovementDirection == .right {
            // posisi bayi di kiri box
            targetX = box.position.x - (box.size.width / 2) - offset
        } else {
            // posisi bayi di kanan box
            targetX = box.position.x + (box.size.width / 2) + offset
        }

        bayi.position.x = targetX
    }

    private func stopContinuousMovement() {
        movementTimer?.invalidate()
        movementTimer = nil

        if isWalkingAnimationPlaying {
            isWalkingAnimationPlaying = false
            bayi.removeAllActions()
            setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))
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

    private func transitionToNextScene() {
        let blackOverlay = SKSpriteNode(color: .black, size: size)
        blackOverlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackOverlay.zPosition = 110
        blackOverlay.alpha = 0
        addChild(blackOverlay)

        let fadeIn = SKAction.fadeIn(withDuration: 2.0)
        fadeIn.timingMode = .easeIn
        blackOverlay.run(fadeIn) { [weak self] in
            guard let self = self else { return }

            let transitionLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
            transitionLabel.text = "Ceritanya udah berhasil buka pintu ya ges, ngantuk..."
            transitionLabel.fontSize = 25
            transitionLabel.fontColor = .white
            transitionLabel.position = CGPoint(
                x: self.size.width / 2 + 100, y: self.size.height / 2)
            transitionLabel.zPosition = 111
            transitionLabel.alpha = 0
            self.addChild(transitionLabel)

        
            let fadeInText = SKAction.fadeIn(withDuration: 1.0)
            transitionLabel.run(fadeInText)

            DispatchQueue.main.asyncAfter(
                deadline: .now() + TimeInterval(3.0)
            ) {
                let nextScene = Level1Stage2Scene(size: self.size)
                let transition = SKTransition.fade(withDuration: 1.5)
                self.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
    
    internal func setBabyTexture(_ texture: SKTexture) {
        bayi.texture = texture
        let scale = babyTargetWidth / texture.size().width
        bayi.size = CGSize(width: babyTargetWidth, height: texture.size().height * scale)
    }
    
    private func stopAllCurrentActions() {
        bayi.removeAllActions()
        setBabyTexture(SKTexture(imageNamed: "baby_idle_stand"))
        bayi.removeAction(forKey: "walk")
        bayi.removeAction(forKey: "move")
        bayi.removeAction(forKey: "jump")
    }

}
