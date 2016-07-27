//
//  CabItem.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 04/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

import SpriteKit

class CabNo{
    var first: No?
    var last: No?
    var curr: No?
//    let frameHeight: Int
//    let frameWidth: Int
    
    init(rows: Int, cols: Int, circleRadius: Int, initialPoint: CGPoint, orientacao: UIInterfaceOrientation){
        curr = No(row: 0, col: 0, circleRadius: circleRadius,initialPoint: initialPoint, orientacao: orientacao)
        first = curr
        last = curr
        
    }
    
    func getFirst() -> No{
        return first!
    }
    
    func setFirst(first: No) {
        self.first = first
    }
    
    func getLast() -> No{
        return last!
    }
    
    func setLast(last: No) {
        self.last = last
    }
    
    func getCurr() -> No{
        return curr!
    }
    
    func setCurr(curr: No) {
        self.curr = curr
    }
    func nodeAlreadyExists(row: Int, col:Int) -> Bool{
        return true
    }
    func getNodeAt(row: Int, col:Int) -> No {
        var no = first
        
        for _ in 0..<row{
            no = no!.down!
        }
        for _ in 0..<col{
            no = no!.right!
        }
        return no!
    }
}