//
//  circle.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 14/04/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Circle: Shapes{
    //let color: String? = nil
    var colorRGB: SKColor
    //var img : Ponto
    var img : SKShapeNode
    let cg: CGPoint
    let l: Int
    let c: Int
    
    init(l: Int, c:Int) {
        
        self.l = l
        self.c = c
        img = SKShapeNode(circleOfRadius: 10)
        //img.userInteractionEnabled = true
        
        let random = Int(arc4random_uniform(5)+1)
        if (random == 1){//cor azul
            self.colorRGB = SKColor.blueColor()
            self.img.fillColor = self.colorRGB
            //img.changeFillColor(colorRGB)
        }
        else if (random == 2){//cor verde
            self.colorRGB = SKColor.greenColor()
            self.img.fillColor = self.colorRGB
            //img.changeFillColor(colorRGB)
        }
        else if (random == 3){ //cor amarela
            self.colorRGB = SKColor.yellowColor()
            self.img.fillColor = self.colorRGB
            //img.changeFillColor(colorRGB)
        }
        else if (random == 4){ //cor vermelha
            self.colorRGB = SKColor.redColor()
            self.img.fillColor = self.colorRGB
            //img.changeFillColor(colorRGB)
        }
        else{ //cor roxa
            self.colorRGB = SKColor.purpleColor()
            self.img.fillColor = self.colorRGB
            //img.changeFillColor(colorRGB)
        }
        cg = CGPoint(x:(l+1) * 40, y:(c+1) * 40)
        self.img.position = CGPointMake(cg.x, cg.y)
        
    }
    func getTipe() -> Shapes {
        return self
    }
    func isBlocked() -> Bool {
        return false
    }
    
}