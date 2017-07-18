//
//  TractorBeam.swift
//  SpaceCows
//
//  Created by Grace Hauk on 7/15/17.
//  Copyright © 2017 Grace Hauk. All rights reserved.
//

import SpriteKit

class TractorBeam: SKSpriteNode {
    
    init(_ size: CGSize)
    {
        let texture = SKTexture(imageNamed: "tractorBeam")
        super.init(texture: texture, color: UIColor.clear, size: size) //texture.size())
        self.name = "tractorBeam"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
