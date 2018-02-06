//
//  ObjectCollider.swift
//  TurtleSurvival
//
//  Created by student on 10/12/17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation

import SpriteKit

//The custom SKNode class for generation of the enemies in our game
class ObjectCollider: SKNode
{
    init(imageNamed: String, name: String, position: CGPoint, color: UIColor, blendFactor: CGFloat, categoryMask: UInt32, contactMask: UInt32, zPosition: CGFloat)
    {
        super.init()
        self.position = position
        
        //Mark: - Custom SKTexture -
        let spriteTexture = SKTexture(imageNamed: imageNamed)
        
        //Mark: - Custom SKSpriteNode -
        let sprite = SKSpriteNode(texture: spriteTexture)
        
        //Mark: - Custom SpriteObject added with physics properties -
        let spriteObject = SKSpriteNode(texture: spriteTexture)
        sprite.name = name
        sprite.physicsBody = SKPhysicsBody(texture: spriteTexture,
                                                      size: CGSize(width: spriteObject.size.width,
                                                                   height: spriteObject.size.height))
        sprite.color = color
        sprite.colorBlendFactor = blendFactor
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = categoryMask
        sprite.physicsBody?.contactTestBitMask = contactMask
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        sprite.zPosition = zPosition
        
        print("Adding monster")
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


