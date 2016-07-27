//
//  Matriz.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 04/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//
import SpriteKit

class Matriz{
    var maxRows : Int, maxCols: Int
    var headNo: CabNo
    //let frameHeight: Int, frameWidth: Int
    //let initialPointX: Int, initialPointY: Int
    let CGinitialPoint: CGPoint
    let circleRadius: Int
    let orientacao: UIInterfaceOrientation?
    
    init(linhas: Int , colunas: Int, circleRadius: Int, initialPointX: Int, initialPointY: Int){
        maxRows = linhas
        maxCols = colunas
        CGinitialPoint = CGPoint(x: CGFloat(initialPointX), y: CGFloat(initialPointY))
        self.circleRadius = circleRadius
        orientacao = UIInterfaceOrientation.Portrait
        headNo = CabNo(rows: maxRows, cols: maxCols, circleRadius: circleRadius,initialPoint: CGinitialPoint, orientacao: orientacao!)
        createMatrix()
        
    }
    init(linhas: Int , colunas: Int, circleRadius: Int, initialPointX: Int, initialPointY: Int, orientacao: UIInterfaceOrientation){
        maxRows = linhas
        maxCols = colunas
        CGinitialPoint = CGPoint(x: CGFloat(initialPointX), y: CGFloat(initialPointY))
        self.circleRadius = circleRadius
        headNo = CabNo(rows: maxRows, cols: maxCols, circleRadius: circleRadius,initialPoint: CGinitialPoint, orientacao: orientacao)
        self.orientacao = orientacao
        createMatrix()
        
    }
    
    private func createMatrix(){
        
        for _ in 1..<maxCols{
            headNo.curr = matrixLine()
        }
        
        while headNo.curr!.left != nil{
            headNo.curr = headNo.curr!.left!
        }
        for _ in 0..<maxCols{
            for _ in 0..<maxRows-1{
                headNo.curr = matrixCol()
            }
            while headNo.curr!.up != nil {
                headNo.curr = headNo.curr!.up!
            }
            if headNo.curr!.right != nil{
                headNo.curr = headNo.curr!.right!
            }
        }
        headNo.last = headNo.curr
        headNo.curr = headNo.first
        //link das colunas
        for _ in 0..<maxCols-1{
            while headNo.curr!.down != nil{
                headNo.curr = headNo.curr!.down!
                linkMatrix(headNo.curr!.row, col: headNo.curr!.col+1)
            }
            while headNo.curr!.up != nil{
                headNo.curr = headNo.curr!.up!
            }
            headNo.curr = headNo.curr!.right!
        }
        
    }
    
    
    
    private func matrixLine()-> No{
        let next = No(row: headNo.curr!.row, col: headNo.curr!.col+1, circleRadius: circleRadius, initialPoint: CGinitialPoint, orientacao: orientacao!)
        headNo.curr!.right = next
        next.left = headNo.curr
        headNo.curr = next
        
        return headNo.curr!
    }
    
    private func matrixCol()-> No{
        let next = No(row: headNo.curr!.row + 1, col: headNo.curr!.col, circleRadius: circleRadius, initialPoint: CGinitialPoint, orientacao: orientacao!)

        headNo.curr!.down = next
        next.up = headNo.curr
        headNo.curr = next
        
        return headNo.curr!
    }
    private func linkMatrix(row: Int, col: Int){
        var no = headNo.first
        for _ in 0..<col{
            no = no!.right!
        }
        for _ in 0..<row{
            no = no!.down!
        }
        headNo.curr!.right = no
        no!.left = headNo.curr
        
    }
}