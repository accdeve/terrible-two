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

    private func setupScene() {
        createBackground()
        createBaby()
        createBox()
        createBebek()
        createPictureFrame()
        createDoor()
    }

    func createBaby() {
        bayi = SKSpriteNode(imageNamed: "baby_sit")

        let targetWidth: CGFloat = 75.0

        let textureSize = bayi.texture?.size() ?? CGSize(width: 1, height: 1)
        let scaleFactor = targetWidth / textureSize.width

        bayi.setScale(scaleFactor)  // Skala proporsional, tidak stretch

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
        box.size = CGSize(width: 50, height: 60)
        box.position = CGPoint(x: size.width * 0.40, y: size.height * 0.15)
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
            } else if node.name == "doorGround" {
                handleDoorTouch()
                break
            }
        }
    }

    private func handleDoorTouch() {

        isBoxClicked = false
        box.color = .white
        self.setSwipeGesture(enabled: false)

        let target = CGPoint(x: door.position.x - 40, y: door.position.y - 90)
        let distance = hypot(
            bayi.position.x - target.x, bayi.position.y - target.y)

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
                // jalankan animasi naik box lalu buka pintu
            } else {
                print("Box belum di pintu, bayi ngambek.")
                self.bayi.run(WalkingAnimationBaby.gapaiAnimation()) {
                    self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
                }
            }
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
        }
        bayi.run(WalkingAnimationBaby.delayAnimation()) {
            self.bayi.run(WalkingAnimationBaby.gapaiAnimation()) {
                self.bayi.run(WalkingAnimationBaby.ngambekAnimation())
            }
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
                    ? WalkingAnimationBaby.walkForwardAnimation()
                    : WalkingAnimationBaby.walkBackwardAnimation()

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
