//
//  WalkingAnimationBaby.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//

import SpriteKit

class WalkingAnimationBaby {
    static func walkForwardAnimation(
        using setter: @escaping (SKTexture) -> Void
    ) -> SKAction {
        let frames = (1...5).map {
            SKTexture(imageNamed: "baby_walk_right\($0)")
        }
        let actions = frames.map { texture in
            SKAction.sequence([
                SKAction.run { setter(texture) },
                SKAction.wait(forDuration: 0.1),
            ])
        }
        return SKAction.repeatForever(SKAction.sequence(actions))
    }

    static func walkBackwardAnimation(
        using setter: @escaping (SKTexture) -> Void
    ) -> SKAction {
        let frames = (1...5).map {
            SKTexture(imageNamed: "baby_walk_left\($0)")
        }
        let actions = frames.map { texture in
            SKAction.sequence([
                SKAction.run { setter(texture) },
                SKAction.wait(forDuration: 0.1),
            ])
        }
        return SKAction.repeatForever(SKAction.sequence(actions))
    }

    static func walkLowRight(using setter: @escaping (SKTexture) -> Void)
        -> SKAction
    {
        let frames = (1...3).map {
            SKTexture(imageNamed: "baby_push_right\($0)")
        }
        let actions = frames.map { texture in
            SKAction.sequence([
                SKAction.run { setter(texture) },
                SKAction.wait(forDuration: 0.15),
            ])
        }
        return SKAction.repeatForever(SKAction.sequence(actions))
    }

    static func walkLowRightBackward(
        using setter: @escaping (SKTexture) -> Void
    ) -> SKAction {
        let frames = (1...3).map {
            SKTexture(imageNamed: "baby_push_left\($0)")
        }
        let actions = frames.map { texture in
            SKAction.sequence([
                SKAction.run { setter(texture) },
                SKAction.wait(forDuration: 0.15),
            ])
        }
        return SKAction.repeatForever(SKAction.sequence(actions))
    }

    static func gapaiAnimation(using setter: @escaping (SKTexture) -> Void)
        -> SKAction
    {
        let frames = [
            SKTexture(imageNamed: "baby_jumping1"),
            SKTexture(imageNamed: "baby_jumping2"),
        ]
        let actions = frames.map { texture in
            SKAction.sequence([
                SKAction.run { setter(texture) },
                SKAction.wait(forDuration: 0.3),
            ])
        }
        return SKAction.repeat(SKAction.sequence(actions), count: 5)
    }
}
