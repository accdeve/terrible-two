//
//  test.swift
//  terrible-two
//
//  Created by Samuel Andrey Aji Prasetya on 06/05/25.
//

import SpriteKit
import SwiftUI

class Level1Stage1Scene: SKScene {
    // Configuration
    private let doorOpenHeight: CGFloat = 350
    private let doorMinOpenThreshold: CGFloat = 220  // Minimum height needed to consider door open
    private let transitionDelay: TimeInterval = 3.0  // Longer delay before scene transition
    private let hintShowDelay: TimeInterval = 4.0
    private let doorReturnDuration: TimeInterval = 0.7  // Duration for door to return if not opened enough

    // Scene elements
    private var hintNode: SKNode?
    private var hintShowing = false
    private var doorOpened = false
    private var isDragging = false
    private var doorInitialPosition: CGPoint = .zero
    private var touchStartPosition: CGPoint = .zero
    private var doorMaxHeight: CGFloat = 0
    private var doorDragProgress: CGFloat = 0  // 0 to 1 progress of door opening

    // Visual effects
    private var lightRays: SKNode?
    private var particles: SKEmitterNode?

    override func didMove(to view: SKView) {
        backgroundColor = .white

        // Setup scene elements
        setupBackground()
        setupBabyBox()
        setupDoor()
        setupLightRays()

        // Schedule hint display after a delay
        let waitAction = SKAction.wait(forDuration: hintShowDelay)
        let showHintAction = SKAction.run { [weak self] in
            self?.showHint()
        }
        run(SKAction.sequence([waitAction, showHintAction]))
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "babyboxbackground")
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let widthScale = size.width / background.size.width
        let heightScale = size.height / background.size.height
        let scale = max(widthScale, heightScale)
        background.setScale(scale)
        addChild(background)

        // Add immersive "breathing" animation to simulate baby's view
//        let scaleUp = SKAction.scale(by: 1.03, duration: 2.2)
//        scaleUp.timingMode = .easeInEaseOut
//        let scaleDown = SKAction.scale(to: scale, duration: 2.2)
//        scaleDown.timingMode = .easeInEaseOut
//        let breathe = SKAction.sequence([scaleUp, scaleDown])
//        background.run(SKAction.repeatForever(breathe))
    }
    
    private func setupBabyBox() {
        let babybox = SKSpriteNode(imageNamed: "babybox")
        babybox.zPosition = 1
        babybox.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let widthScale = size.width / babybox.size.width
        let heightScale = size.height / babybox.size.height
        let scale = max(widthScale, heightScale)
        babybox.setScale(scale)
        addChild(babybox)

        // Add immersive "breathing" animation to simulate baby's view
        let scaleUp = SKAction.scale(by: 1.03, duration: 2.2)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: scale, duration: 2.2)
        scaleDown.timingMode = .easeInEaseOut
        let breathe = SKAction.sequence([scaleUp, scaleDown])
        babybox.run(SKAction.repeatForever(breathe))
    }

    private func setupDoor() {
        let door = SKSpriteNode(imageNamed: "babyboxdoor")
        door.name = "door"
        door.zPosition = 2
        door.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let widthScale = size.width / door.size.width
        let heightScale = size.height / door.size.height
        let scale = max(widthScale, heightScale)
        door.setScale(scale)

        // Store initial position for later use
        doorInitialPosition = door.position
        doorMaxHeight = doorOpenHeight
        
        let scaleUp = SKAction.scale(by: 1.03, duration: 2.2)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: scale, duration: 2.2)
        scaleDown.timingMode = .easeInEaseOut
        let breathe = SKAction.sequence([scaleUp, scaleDown])
        door.run(SKAction.repeatForever(breathe))
        
        addChild(door)
    }

    private func setupLightRays() {
        let rays = SKNode()
        rays.name = "light-rays"
        rays.position = CGPoint(x: size.width / 2, y: size.height / 2)
        rays.zPosition = 0.8
        rays.alpha = 0

        addChild(rays)
        lightRays = rays
    }

    // MARK: - Touch Handling for Dragging
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !doorOpened, let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodes = nodes(at: location)

        if let door = nodes.first(where: { $0.name == "door" }) {
            isDragging = true
            touchStartPosition = location

            // Hide hint when user starts interacting
            hideHint()

            // Stop any existing door animations
            door.removeAllActions()
            if let shadow = door.childNode(withName: "door-shadow") {
                shadow.removeAllActions()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDragging, !doorOpened, let touch = touches.first,
            let door = childNode(withName: "door") as? SKSpriteNode
        else { return }

        let location = touch.location(in: self)
        let deltaY = max(0, location.y - touchStartPosition.y)

        // Calculate progress (0 to 1)
        doorDragProgress = min(1.0, deltaY / doorMaxHeight)

        // Move door based on drag with some resistance for realism
        let newY = doorInitialPosition.y + (deltaY * 0.8)
        door.position.y = newY

        // Gradually show light rays based on how much door is open
        if let rays = lightRays {
            rays.alpha = doorDragProgress * 0.8
        }

        // If door is over 90% open, trigger the completion
        if doorDragProgress >= 0.9 && !doorOpened {
            doorOpened = true
            completeDoorOpening(door)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endDragging()
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>, with event: UIEvent?
    ) {
        endDragging()
    }

    private func endDragging() {
        guard isDragging, !doorOpened,
            let door = childNode(withName: "door") as? SKSpriteNode
        else { return }

        isDragging = false

        // If door wasn't opened enough, return it to initial position with bounce effect
        if doorDragProgress < 0.6 {
            let moveDown = SKAction.move(
                to: doorInitialPosition, duration: doorReturnDuration)
            moveDown.timingMode = .easeIn

            // Create a gentle bounce effect
            let slightBounce = SKAction.sequence([
                SKAction.moveBy(x: 0, y: 5, duration: 0.1),
                SKAction.moveBy(x: 0, y: -5, duration: 0.1),
            ])

            let sequence = SKAction.sequence([moveDown, slightBounce])
            door.run(sequence)

            // Fade out light rays
            if let rays = lightRays {
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                rays.run(fadeOut)
            }

            // Return rotation to normal
            let rotateBack = SKAction.rotate(
                toAngle: 0, duration: doorReturnDuration)
            door.run(rotateBack)

            // Show hint again after a delay if door wasn't opened
            let waitAction = SKAction.wait(forDuration: 2.0)
            let showHintAction = SKAction.run { [weak self] in
                self?.showHint()
            }
            run(SKAction.sequence([waitAction, showHintAction]))
        }
        // If door was opened enough but not fully, complete the opening
        else if !doorOpened {
            doorOpened = true
            completeDoorOpening(door)
        }
    }

    private func completeDoorOpening(_ door: SKSpriteNode) {
        // Calculate remaining distance to fully open
        let remainingDistance =
            doorMaxHeight - (door.position.y - doorInitialPosition.y)
        let duration = max(0.3, min(0.8, Double(remainingDistance / 200)))

        // Complete the door opening with dynamic duration
        let completeOpen = SKAction.moveBy(
            x: 0, y: remainingDistance, duration: duration)
        completeOpen.timingMode = .easeOut

        func showHint() {
            if hintShowing || doorOpened { return }

            hintShowing = true

            // Create hint container
            let hintContainer = SKNode()
            hintContainer.name = "hint"
            hintContainer.position = CGPoint(
                x: size.width / 2, y: size.height / 2)
            hintContainer.zPosition = 10

            // Semi-transparent background
            let background = SKShapeNode(
                rectOf: CGSize(
                    width: size.width * 0.8, height: size.height * 0.2))
            background.fillColor = SKColor.black.withAlphaComponent(0.7)
            background.strokeColor = SKColor.white
            background.lineWidth = 2
            hintContainer.addChild(background)

            // Text hint
            let hint = SKLabelNode(fontNamed: "AvenirNext-Bold")
            hint.text = "Swipe UP to open the box"
            hint.fontSize = 24
            hint.fontColor = .white
            hint.position = CGPoint(x: 0, y: -10)
            hintContainer.addChild(hint)

            // Arrow animation
            let arrow = SKShapeNode()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: -40))
            path.addLine(to: CGPoint(x: 0, y: 20))
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.move(to: CGPoint(x: 0, y: 20))
            path.addLine(to: CGPoint(x: -15, y: 0))

            arrow.path = path.cgPath
            arrow.strokeColor = .white
            arrow.lineWidth = 3
            arrow.position = CGPoint(x: 0, y: -50)
            hintContainer.addChild(arrow)

            // Arrow animation
            let moveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.7)
            let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 0.7)
            let moveDown = SKAction.moveBy(x: 0, y: -30, duration: 0)
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0)
            let arrowSequence = SKAction.sequence([
                SKAction.group([moveUp, fadeOut]),
                SKAction.group([moveDown, fadeIn]),
            ])
            arrow.run(SKAction.repeatForever(arrowSequence))

            // Fade in the hint
            hintContainer.alpha = 0
            let fadeIn2 = SKAction.fadeIn(withDuration: 0.5)
            hintContainer.run(fadeIn2)

            addChild(hintContainer)
            hintNode = hintContainer
        }

        // Fully illuminate light rays
        if let rays = lightRays {
            let brighten = SKAction.fadeAlpha(to: 1.0, duration: duration / 2)
            rays.run(brighten)
        }

        // Dramatic rotation effect
        let finalRotate = SKAction.rotate(toAngle: 0.1, duration: duration)

        // Create an action group for simultaneous effects
        let finalEffects = SKAction.group([completeOpen, finalRotate])

        door.run(finalEffects) { [weak self] in
            // Create a bright flash
            self?.createFlashEffect()

            // Wait a moment, then transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.transitionToNextScene()
            }
        }
    }

    private func createFlashEffect() {
        let flash = SKSpriteNode(color: .white, size: size)
        flash.position = CGPoint(x: size.width / 2, y: size.height / 2)
        flash.zPosition = 100
        flash.alpha = 0
        addChild(flash)

        // Flashbang-style sequence
        let flashSequence = SKAction.sequence([
            SKAction.fadeAlpha(to: 1.0, duration: 0.05),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeOut(withDuration: 1.0),
        ])
        run(SKAction.playSoundFileNamed("flash.mp3", waitForCompletion: false))

        flash.run(flashSequence) {
            flash.removeFromParent()
        }
    }

    private func showHint() {
        if hintShowing || doorOpened || isDragging { return }

        hintShowing = true

  
        let hintContainer = SKNode()
        hintContainer.name = "hint"
        hintContainer.position = CGPoint(
            x: size.width / 2, y: size.height / 2 - 70)
        hintContainer.zPosition = 10


        let background = SKShapeNode(
            rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.25))
        background.fillColor = SKColor.black.withAlphaComponent(0.6)
        background.strokeColor = SKColor.white.withAlphaComponent(0.8)
        background.lineWidth = 2
        background.alpha = 0.9
        hintContainer.addChild(background)

        // Animated hand icon showing drag motion
        let handNode = SKNode()
        handNode.position = CGPoint(x: 0, y: 100)

        if let handImage = UIImage(named: "hand") {
            let texture = SKTexture(image: handImage)
            let hand = SKSpriteNode(texture: texture)
            hand.size = CGSize(width: 40, height: 40)
            hand.alpha = 0.9
            handNode.addChild(hand)
        }

        hintContainer.addChild(handNode)

        // Text hint
        let hint = SKLabelNode(fontNamed: "AvenirNext-Bold")
        hint.text = "Drag the door UP to open"
        hint.fontSize = 24
        hint.fontColor = .white
        hint.position = CGPoint(x: 0, y: 20)
        hintContainer.addChild(hint)

        // Detailed instruction
        let detailHint = SKLabelNode(fontNamed: "AvenirNext-Regular")
        detailHint.text = "Use your finger to pull the lid upward"
        detailHint.fontSize = 16
        detailHint.fontColor = SKColor(white: 0.9, alpha: 1.0)
        detailHint.position = CGPoint(x: 0, y: 0)
        hintContainer.addChild(detailHint)

        // Animated drag motion
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 1.0)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SKAction.moveBy(x: 0, y: -50, duration: 0.5)
        moveDown.timingMode = .easeIn
        let handSequence = SKAction.sequence([
            moveUp,
            SKAction.wait(forDuration: 0.2),
            moveDown,
            SKAction.wait(forDuration: 0.5),
        ])
        handNode.run(SKAction.repeatForever(handSequence))

        // Subtle pulsing effect on the whole hint
        let pulseSmall = SKAction.scale(to: 0.95, duration: 1.2)
        pulseSmall.timingMode = .easeInEaseOut
        let pulseNormal = SKAction.scale(to: 1.0, duration: 1.2)
        pulseNormal.timingMode = .easeInEaseOut
        let pulsing = SKAction.sequence([pulseSmall, pulseNormal])
        hintContainer.run(SKAction.repeatForever(pulsing))

        hintContainer.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.8)
        hintContainer.run(fadeIn)

        addChild(hintContainer)
        hintNode = hintContainer
    }

    private func hideHint() {
        if let hint = hintNode {
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            hint.run(fadeOut) {
                hint.removeFromParent()
            }
            hintNode = nil
            hintShowing = false
        }
    }

    private func transitionToNextScene() {
        let blackOverlay = SKSpriteNode(color: .black, size: size)
        blackOverlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackOverlay.zPosition = 100
        blackOverlay.alpha = 0
        addChild(blackOverlay)

        let fadeIn = SKAction.fadeIn(withDuration: 2.0)
        fadeIn.timingMode = .easeIn
        blackOverlay.run(fadeIn) { [weak self] in
            guard let self = self else { return }

            let transitionLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
            transitionLabel.text = "The Baby Escaped..."
            transitionLabel.fontSize = 32
            transitionLabel.fontColor = .white
            transitionLabel.position = CGPoint(
                x: self.size.width / 2, y: self.size.height / 2)
            transitionLabel.zPosition = 101
            transitionLabel.alpha = 0
            self.addChild(transitionLabel)

        
            let fadeInText = SKAction.fadeIn(withDuration: 1.0)
            transitionLabel.run(fadeInText)

            DispatchQueue.main.asyncAfter(
                deadline: .now() + self.transitionDelay
            ) {
                let nextScene = Level1Stage2Scene(size: self.size)
                let transition = SKTransition.fade(withDuration: 1.5)
                self.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
}
