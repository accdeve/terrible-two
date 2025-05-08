//
//  MakeNode.swift
//  terrible-two
//
//  Created by aditya ibnu arif on 06/05/25.
//

import SpriteKit

func createNode(imageNamed: String? = nil,
                color: SKColor = .clear,
                size: CGSize,
                position: CGPoint,
                zPosition: CGFloat = 0,
                name: String? = nil) -> SKSpriteNode {
    
    let node: SKSpriteNode
    
    if let imageName = imageNamed {
        node = SKSpriteNode(imageNamed: imageName)
    } else {
        node = SKSpriteNode(color: color, size: size)
    }
    
    node.size = size
    node.position = position
    node.zPosition = zPosition
    node.name = name
    
    return node
}
