//
//  Shapes.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 13/04/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

import SpriteKit

protocol Shapes {
    
    var initialPoint: CGPoint {get set}
    var lastPoint:CGPoint {get set}
    var inicialPointLandscape: CGPoint {get set}
    var lastPointLandscape: CGPoint {get set}
    
    func getTipe() -> Shapes
    func isBlocked() -> Bool

}