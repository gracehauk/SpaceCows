//
//  GameScene.swift
//  SpaceCows
//
//  Created by Grace on 7/2/17.
//  Copyright © 2017 Grace Hauk. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    let player = SKSpriteNode(imageNamed: "cowboy")
    var cowArray: [Cow] = []
    var numberOfCows = 10
    var theGround : SKSpriteNode? = nil
    var theUFO : UFO? = nil
    var theScoreLabel : SKLabelNode? = nil
    var numberOfCowsSaved: Int = 0
    var start:SKLabelNode!
    var click:SKLabelNode!
    var started = false
    var gameOver:SKLabelNode!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            //start tapped
            if start.contains(location)
            {
                start.text = ""
                click.text = ""
                started = true
                startGame()
                
            }
        }
    }
    override func didMove(to view: SKView)
    {
        createStart()
    }
    
    func handleUFO_GroundContact(theUFO: UFO, theUFOGround: SKNode)
    {
        let theInterestingCow = cowArray[theUFO.cowIndex!]
        let tractorBeamXPosition = (theUFOGround.position.x)
        let tractorBeamYPosition = (theUFOGround.position.y)-(theUFOGround.frame.height)
        let tractorBeamHeight = tractorBeamYPosition - (theInterestingCow.position.y)
        let theTractorBeam = theUFO.produceTractorBeam(width: (theUFOGround.frame.width)/2,
                                                       position: CGPoint(x: tractorBeamXPosition,
                                                                         y: tractorBeamYPosition),
                                                       height: tractorBeamHeight)
        addChild(theTractorBeam!)
    }
    
    func handleUFO_ProjectileContact(theUFO: UFO, theProjectile: SKNode)
    {
        theUFO.handleUFO_ProjectileContact(theUFO: theUFO, theProjectile: theProjectile)
    }
    
    func handleCow_TheEarth_Contact(theCow: Cow, theEarth: SKNode)
    {
        theCow.physicsBody?.affectedByGravity = false
        theCow.physicsBody?.isDynamic = false
        theCow.beingPursuedByA_UFO = false
        self.numberOfCowsSaved = self.numberOfCowsSaved + 1
        theScoreLabel?.text = "Cows Saved: \(self.numberOfCowsSaved)"
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        var theUFO : SKNode?
        var theUFOGround : SKNode?
        var theProjectile : SKNode?
        var theCow : SKNode?
        var theEarth : SKNode?
        
        if ( ((contact.bodyA.node?.name) == "ufo") && ((contact.bodyB.node?.name) == "ufoGround") )
        {
            theUFO = contact.bodyA.node
            theUFOGround = contact.bodyB.node as? SKSpriteNode
            handleUFO_GroundContact(theUFO: theUFO as! UFO, theUFOGround: theUFOGround!)
            return
        }
            
        if (contact.bodyA.node?.name == "ufoGround" && contact.bodyB.node?.name == "ufo")
        {
            theUFOGround = contact.bodyA.node
            theUFO = contact.bodyB.node
            handleUFO_GroundContact(theUFO: theUFO as! UFO, theUFOGround: theUFOGround!)
            return
        }
        
        if ( ((contact.bodyA.node?.name) == "ufo") && ((contact.bodyB.node?.name) == "projectile") )
        {
            theUFO = contact.bodyA.node
            theProjectile = contact.bodyB.node as? SKSpriteNode
            handleUFO_ProjectileContact(theUFO: theUFO as! UFO, theProjectile: theProjectile!)
            return
        }
        
        if (contact.bodyA.node?.name == "projectile" && contact.bodyB.node?.name == "ufo")
        {
            theProjectile = contact.bodyA.node
            theUFO = contact.bodyB.node
            handleUFO_ProjectileContact(theUFO: theUFO as! UFO, theProjectile: theProjectile!)
            return
        }
        
        if ( ((contact.bodyA.node?.name) == "cow") && ((contact.bodyB.node?.name) == "theEarth") )
        {
            theCow = contact.bodyA.node
            theEarth = contact.bodyB.node
            handleCow_TheEarth_Contact(theCow: theCow as! Cow, theEarth: theEarth!)
        }
        
        if (contact.bodyA.node?.name == "theEarth" && contact.bodyB.node?.name == "cow")
        {
            theEarth = contact.bodyA.node
            theCow = contact.bodyB.node
            handleCow_TheEarth_Contact(theCow: theCow as! Cow, theEarth: theEarth!)
        }
    }

    func addCow()
    {
        let thisCow = Cow()
        
        var allClearToPlaceCow = false
        
        while (!allClearToPlaceCow)
        {
            // Determine where to spawn the cow along the x axis
            let thisCowX = random(min: thisCow.size.width/2, max: size.width - thisCow.size.width/2)
            
            let theCowY = (self.theGround?.frame.maxY)! + thisCow.size.height/2.0
            thisCow.position = CGPoint(x: thisCowX, y: theCowY)
            
            var overlapsAtLeastOne = false
            
            for theCow in cowArray {
                if theCow.overlapsOtherCow(thisCow)
                {
                    overlapsAtLeastOne = true
                    break
                }
            }
            if !overlapsAtLeastOne {
                allClearToPlaceCow = true
            }
        }
        
        // Add the cow to the scene
        addChild(thisCow)
        cowArray.append(thisCow)
    }
    
    
    
    func chooseRandomAvailableCowIndex() -> Int
    {
        var cowsAreAvailable = false
        
        for cow in cowArray
        {
            if !cow.beingPursuedByA_UFO
            {
                cowsAreAvailable = true
                break
            }
        }
        
        if (!cowsAreAvailable)
        {
            return -1
        }
        
        while(true)
        {
            let randomCowIndexChoice = Int(CGFloat(numberOfCows)*random())
            if (!cowArray[randomCowIndexChoice].beingPursuedByA_UFO)
            {
                cowArray[randomCowIndexChoice].beingPursuedByA_UFO = true
                return randomCowIndexChoice
            }
        }
    }
    

    func addUFO()
    {
        let cowIndex = chooseRandomAvailableCowIndex()
        if (cowIndex == -1)
        {
            // its the end of the games
            showGameOverLabel()
        }
        
        if (cowIndex != -1)
        {
            let theUFO = UFO(cowIndex,theCowArray: cowArray,theScene: self)
            theUFO.position = CGPoint(x: cowArray[cowIndex].position.x, y: frame.height)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.name = "projectile"
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(rectangleOf: (projectile.size))
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.isDynamic = false
        projectile.physicsBody?.categoryBitMask = ProjectileUFOCategory
        projectile.physicsBody?.collisionBitMask = ProjectileUFOCategory
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.y < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    func createStart()
    {
        start = SKLabelNode(text: "Space Cows")
        start.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        start.fontColor = UIColor.yellow
        click = SKLabelNode(text: "Tap to start")
        click.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        click.fontColor = UIColor.red
        
        addChild(start)
        addChild(click)
    }
    
    func showGameOverLabel()
    {
        gameOver = SKLabelNode(text: "Game Over")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        gameOver.fontColor = UIColor.yellow
        addChild(gameOver)
    }
    
    func startGame()
    {
        physicsWorld.contactDelegate = self
        
        theScoreLabel = SKLabelNode(text: "Cows Saved: \(numberOfCowsSaved)")
        theScoreLabel?.position = CGPoint(x: size.width * 0.8,
                                          y: size.height * 0.1)
        theScoreLabel?.fontSize = 20
        theScoreLabel?.color = .yellow
        
        addChild(theScoreLabel!)
        
        backgroundColor = SKColor.black
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        addChild(player)
        
        let backgroundMusic = SKAudioNode(fileNamed: "spaceCowsBackgroundMusic")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        theGround = SKSpriteNode(color: .yellow, size: CGSize(width: self.frame.width,height: 4))
        theGround?.position = CGPoint(x: self.frame.width/2, y: self.size.height * 0.2 )
        theGround?.name = "theEarth"
        theGround?.physicsBody = SKPhysicsBody(rectangleOf: (theGround?.size)!)
        theGround?.physicsBody?.restitution = 0.0
        theGround?.physicsBody?.affectedByGravity = false
        theGround?.physicsBody?.isDynamic = false
        theGround?.physicsBody?.categoryBitMask = CowDynamicsCategory
        theGround?.physicsBody?.collisionBitMask = CowDynamicsCategory
        theGround?.physicsBody?.contactTestBitMask = CowDynamicsCategory
        addChild(theGround!)
        
        for _ in 1...numberOfCows
        {
            addCow()
        }
        
        let theActionSequence = SKAction.sequence([SKAction.run(addUFO),
                                                   SKAction.wait(forDuration: 1.0)])
        
        let theForEverAction = SKAction.repeatForever(theActionSequence)
        //let theSingleAction = SKAction.repeat(theActionSequence, count: 1)
        run(theForEverAction)
        
    }
}
