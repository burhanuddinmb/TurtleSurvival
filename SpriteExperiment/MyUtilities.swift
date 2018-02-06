//
//  MyUtilities.swift
//  TurtleSurvival
//
//  Created by student on 10/13/17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory
{
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
    static let Player    : UInt32 = 0b100   // 2
}

struct visualPosition{
    static let Background :CGFloat = 0
    static let Ground :CGFloat = 1
    static let Player :CGFloat = 2
    static let Arrow :CGFloat = 3
    static let Enemy :CGFloat = 4
    static let Rock :CGFloat = 5
    static let Score :CGFloat = 6
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

func random() -> CGFloat
{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat
{
    return random() * (max - min) + min
}

func randomInt(min: Int, max: Int) -> Int
{
    return (Int(arc4random()) % (max - min)) + min
}
