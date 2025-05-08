//
//  WalkingAnimationBaby.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//

import SpriteKit

class WalkingAnimationBaby {
    static func walkForwardAnimation() -> SKAction {
        let walkFramesForward = (1...3).map {
            SKTexture(imageNamed: "baby_walk_right\($0)")
        }
        let walkForwardAnimation = SKAction.repeatForever(
            SKAction.animate(with: walkFramesForward, timePerFrame: 0.25))
        return walkForwardAnimation
    }

    static func walkBackwardAnimation() -> SKAction {
        let walkFramesBackward = (1...3).map {
            SKTexture(imageNamed: "baby_walk_left\($0)")
        }
        let walkBackwardAnimation = SKAction.repeatForever(
            SKAction.animate(with: walkFramesBackward, timePerFrame: 0.25))
        return walkBackwardAnimation
    }

    static func walkLowRight() -> SKAction {
        let walkFramesForward = (1...2).map {
            SKTexture(imageNamed: "baby_low_right\($0)")
        }
        let walkForwardAnimation = SKAction.repeatForever(
            SKAction.animate(with: walkFramesForward, timePerFrame: 0.25))
        return walkForwardAnimation
    }
    
    static func walkLowRightBackward() -> SKAction {
        let walkFramesBackward = (1...2).reversed().map {
            SKTexture(imageNamed: "baby_low_right\($0)")
        }
        let walkBackwardAnimation = SKAction.repeatForever(
            SKAction.animate(with: walkFramesBackward, timePerFrame: 0.25)
        )
        return walkBackwardAnimation
    }


    static func gapaiAnimation() -> SKAction {
        let gapai = [
            SKTexture(imageNamed: "baby_jumping1"),
            SKTexture(imageNamed: "baby_jumping2"),
        ]

        let gapaiAnimation = SKAction.animate(with: gapai, timePerFrame: 0.3)
        let gapaiAnimationRepeat = SKAction.repeat(gapaiAnimation, count: 5)

        return gapaiAnimationRepeat
    }
    
//    static func ngambekAnimation() -> SKAction {
//        let ngambek = [
//            SKTexture(imageNamed: "baby_sit"),
//            SKTexture(imageNamed: "baby_ngambek1"),
//            SKTexture(imageNamed: "baby_ngambek2"),
//            SKTexture(imageNamed: "baby_ngambek3"),
//        ]
//
//        let ngambekAnimation = SKAction.animate(with: ngambek, timePerFrame: 1)
//
//        return ngambekAnimation
//    }

    static func delayAnimation() -> SKAction {
        let delay = SKAction.wait(forDuration: 3)
        return delay
    }
}
