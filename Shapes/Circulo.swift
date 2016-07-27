//
//  circulo.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 17/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

import SpriteKit

class Circulo: SKShapeNode, Shapes{
    var colorStr: String?
    var colorRGB: SKColor
    var initialPoint: CGPoint // posicao inicial com dispositivo vertical(portrait)
    var lastPoint:CGPoint// posicao final com dispositivo vertical(portrait)
    var inicialPointLandscape: CGPoint
    var lastPointLandscape: CGPoint
    var row: Int
    private var rowAux: Int
    var col: Int
    var blocked: Bool
    var cycle: Bool = false
    //let circleRadius: Int
    var flag = false
    
    init(row: Int, col:Int, circleOfRadius: CGFloat, initalPoint: CGPoint, orientacao: UIInterfaceOrientation) {
        
        self.row = row
        self.col = col
        
        var auxx = 2 * col * Int(circleOfRadius * 2)
        auxx = auxx + Int(initalPoint.x)
        //print("x: \(auxx)")
        rowAux = 4 - row
        var auxy = 2 * rowAux * Int(circleOfRadius * 2)
        auxy = auxy + Int(initalPoint.y) + Int(circleOfRadius)
        //print("y: \(auxy)")
        //print("----------")
        initialPoint = CGPoint(x:auxx, y:auxy)
        lastPoint = CGPoint(x:auxx, y:auxy)
        self.colorRGB = SKColor.whiteColor()
        blocked = false
        
        //preecher pontos para a posicao landscape
        let colAux = 4 - col
        var auxYLand = 2 * colAux * Int(circleOfRadius * 2)
        auxYLand = auxYLand + Int(initalPoint.x) + Int(circleOfRadius)
        inicialPointLandscape = CGPoint (x: initialPoint.y, y: CGFloat( auxYLand))
        lastPointLandscape = CGPoint (x: lastPoint.y, y: CGFloat( auxYLand))
        
        
        super.init()
        let diameter = circleOfRadius * 2
        self.path = CGPathCreateWithEllipseInRect(CGRect(origin: CGPointZero, size: CGSize(width: diameter, height: diameter)), nil)
        
        let random :Int
        if row == 4{
            random = Int(arc4random_uniform(5)+1)
        }else{
            random = Int(arc4random_uniform(6)+1)
        }
        if (random == 1){//cor azul
            self.colorRGB = SKColor.blueColor()
            fillColor = colorRGB
            colorStr = "azul"
        }
        else if (random == 2){//cor verde
            self.colorRGB = SKColor.greenColor()
            fillColor = colorRGB
            colorStr = "verde"
        }
        else if (random == 3){ //cor amarela
            self.colorRGB = SKColor.yellowColor()
            fillColor = colorRGB
            colorStr = "amarela"
        }
        else if (random == 4){ //cor vermelha
            self.colorRGB = SKColor.redColor()
            fillColor = colorRGB
            colorStr = "vermelha"
        }
        else if (random == 5){ //cor roxa
            self.colorRGB = SKColor.purpleColor()
            fillColor = colorRGB
            colorStr = "roxa"
        }else{//cor preta
            self.colorRGB = SKColor.blackColor()
            fillColor = colorRGB
            colorStr = "black"
            self.blocked = true
        }
        if orientacao.isPortrait{
            position = CGPointMake(initialPoint.x, initialPoint.y)
        } else if orientacao.isLandscape {
            position = CGPointMake(inicialPointLandscape.x, inicialPointLandscape.y)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTipe() -> Shapes {
        return self
    }
    func isBlocked() -> Bool {
        return blocked
    }
    func getColorStr() -> String {
        return colorStr!
    }
    func getRow()-> Int{
        return row
    }
    func getCol()-> Int{
        return col
    }
    
}