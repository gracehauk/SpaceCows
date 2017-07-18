//
//  Cow.swift
//  SpaceCows
//
//  Created by Grace Hauk on 7/9/17.
//  Copyright © 2017 Grace Hauk. All rights reserved.
//

import SpriteKit

class Cow: SKSpriteNode {
    
    var beingPursuedByA_UFO: Bool
    
    init()
    {
        beingPursuedByA_UFO = false
        let texture = SKTexture(imageNamed: "cow")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "cow"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = CowDynamicsCategory
        self.physicsBody?.collisionBitMask = CowDynamicsCategory
        self.physicsBody?.contactTestBitMask = CowDynamicsCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func overlapsOtherCow(_ node: SKNode) -> Bool {
        return super.intersects(node)
    }
    
}
