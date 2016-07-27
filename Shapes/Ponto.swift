//
//  Ponto.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 12/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//
import SpriteKit

class Ponto:  SKShapeNode{
    init(circleOfRadius: CGFloat) {
        super.init()
        let diameter = circleOfRadius * 2
        self.path = CGPathCreateWithEllipseInRect(CGRect(origin: CGPointZero, size: CGSize(width: diameter, height: diameter)), nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("cliquei img")

    
    
    //let touch = touches.first
    //let point = touch?.locationInView(touch?.view)
    
    //        let touch = touches.first as UITouch!
    //        let point = touch?.locationInView(touch?.view)
    //
    //       if mapa.getM(0, c: 0).img.containsPoint(point!){
    //            print("shapes")
    //        }
    //        print ("cliquei: \(touch?.locationInView(touch?.view))")
    //        print ("linha matriz: \(mapa.getM(0, c: 0).l)")
    //        print ("coluna matriz: \(mapa.getM(0, c: 0).c)")
    //        print ("ponto: \(mapa.getM(0, c: 0).cg)")
    //
    //    }   
    func changeFillColor(color: SKColor){
        fillColor = color
    }
}
