//
//  Utils.swift
//  SpaceCows
//
//  Created by Grace Hauk on 7/16/17.
//  Copyright © 2017 Grace Hauk. All rights reserved.
//

import GameplayKit

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

extension CGPoint
{
    func length() -> CGFloat
    {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint
    {
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



