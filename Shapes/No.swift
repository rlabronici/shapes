//
//  Item.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 04/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//
import SpriteKit

class No{
    var row : Int
    var col : Int
    var up: No?
    var down: No?
    var left: No?
    var right: No?
    var shape: Shapes?
    var selected = false
    
    init(row: Int, col: Int, circleRadius: Int,initialPoint: CGPoint, orientacao: UIInterfaceOrientation){
        shape = Circulo(row: row,col: col, circleOfRadius: CGFloat(circleRadius), initalPoint: initialPoint, orientacao: orientacao)
        self.row = row
        self.col = col
    }
//    init(row: Int, col: Int){
//        shape = Circulo(row: row,col: col, circleOfRadius: 12)
//        self.row = row
//        self.col = col
//    }

    
}