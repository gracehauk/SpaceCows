//
//  UFO.swift
//  SpaceCows
//
//  Created by Grace Hauk on 7/15/17.
//  Copyright © 2017 Grace Hauk. All rights reserved.
//

import SpriteKit


class UFO: SKSpriteNode {
    
    var cowIndex: Int?
    var myTractorBeam: TractorBeam? = nil
    var myCowArray: [Cow]? = nil
    var myScene: SKScene? = nil
    var myUFOGround: SKSpriteNode? = nil
    var noLongerReadyToBeHitAction : SKAction? = nil
    var UFOGoByeByeAction : SKAction? = nil
    
    init(_ cowIndex: Int, theCowArray: [Cow], theScene: SKScene)
    {
        let texture = SKTexture(imageNamed: "ufo")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "ufo"
        self.cowIndex = cowIndex
        self.myCowArray = theCowArray
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = UFODynamicsCategory | ProjectileUFOCategory
        self.physicsBody?.collisionBitMask = UFODynamicsCategory
        self.physicsBody?.contactTestBitMask = UFODynamicsCategory
        self.myScene = theScene
        
        self.position = CGPoint(x: (self.myCowArray?[cowIndex].position.x)!,
                                y: (self.myScene?.frame.height)!)
        
        
        
        myUFOGround = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.size.width, height: 1))
        myUFOGround?.name = "ufoGround"
        let actualY = random(min: (myScene?.frame.height)!*0.4, max: (myScene?.frame.height)! * 0.6)
        myUFOGround?.position = CGPoint(x: self.position.x, y: actualY)
        
        
        myUFOGround?.physicsBody = SKPhysicsBody(rectangleOf: (myUFOGround?.size)!)
        myUFOGround?.physicsBody?.affectedByGravity = false
        myUFOGround?.physicsBody?.isDynamic = false
        myUFOGround?.physicsBody?.restitution = 0.0
        myUFOGround?.physicsBody?.categoryBitMask = UFODynamicsCategory
        myUFOGround?.physicsBody?.collisionBitMask = UFODynamicsCategory
        myUFOGround?.physicsBody?.contactTestBitMask = UFODynamicsCategory
        myScene?.addChild(self)
        myScene?.addChild(myUFOGround!)

        // ha ha you can't get me anymore
        noLongerReadyToBeHitAction = SKAction.run {
            self.physicsBody?.collisionBitMask = UFODynamicsCategory
            self.physicsBody?.contactTestBitMask = 0
        }
        
        UFOGoByeByeAction = SKAction.run {
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.isDynamic = false
            let whereToGetTo = (self.myScene?.frame.maxY)! + self.size.height
            self.run(SKAction.sequence([SKAction.moveTo(y: whereToGetTo, duration: 0.2),
                                        SKAction.removeFromParent()]))
            self.myUFOGround?.removeFromParent()
            self.myUFOGround = nil
        }
    }
    
    func handleUFO_ProjectileContact(theUFO: UFO, theProjectile: SKNode)
    {
        myTractorBeam?.removeAllActions()
        let theParticularCow = self.myCowArray?[self.cowIndex!]
        theParticularCow?.removeAllActions()
        myTractorBeam?.run(SKAction.removeFromParent())
        self.run(self.UFOGoByeByeAction!)
        
        theParticularCow?.physicsBody?.affectedByGravity = true
        theParticularCow?.physicsBody?.isDynamic = true
        theParticularCow?.physicsBody?.categoryBitMask = CowDynamicsCategory
        theParticularCow?.physicsBody?.collisionBitMask = CowDynamicsCategory
        theParticularCow?.physicsBody?.contactTestBitMask = CowDynamicsCategory
    }
    
    func produceTractorBeam(width: CGFloat,
                            position: CGPoint,
                            height: CGFloat) -> TractorBeam?
    {
        if (myTractorBeam == nil)
        {
            myTractorBeam = TractorBeam(CGSize(width: width, height: 0))
            myTractorBeam?.position = position
            myTractorBeam?.anchorPoint = CGPoint(x: 0.5, y:1.0)
            
            let resizeAction = SKAction.resize(toHeight: height, duration: 0.2)
            let readyToBeHitAction = SKAction.run {
                self.physicsBody?.collisionBitMask = UFODynamicsCategory | ProjectileUFOCategory
                self.physicsBody?.contactTestBitMask = ProjectileUFOCategory
                
            }
            let retractTractorBeamAction = SKAction.resize(toHeight: 0, duration: 2.0)
            let suckUpCowAction = SKAction.run
            {
                let cowPulledAction = SKAction.moveTo(y: position.y, duration: 2.0)
                self.myCowArray?[self.cowIndex!].run(cowPulledAction)
            }
            let suckUpCowActionGroup = SKAction.group([retractTractorBeamAction, suckUpCowAction])
            
            let tractorBeamDoneAction = SKAction.removeFromParent()
            let cowDoneAction = SKAction.run
            {
                self.myCowArray?[self.cowIndex!].run(SKAction.removeFromParent())
            }
            
            let cowGoByeByeGroup = SKAction.group([tractorBeamDoneAction,cowDoneAction])
            
            myTractorBeam?.run(SKAction.sequence([resizeAction,
                                                  readyToBeHitAction,
                                                  suckUpCowActionGroup,
                                                  self.noLongerReadyToBeHitAction!,
                                                  cowGoByeByeGroup,
                                                  self.UFOGoByeByeAction!]))
            
            return myTractorBeam!
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
