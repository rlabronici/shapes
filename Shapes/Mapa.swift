//
//  Mapa.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 13/04/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

import SpriteKit

class Mapa {
    let frameWidth: Int
    let frameHeight: Int
    let circleRadius: Int
    let initialPointX :Int
    let initialPointY :Int
    var numColumns: Int = 5
    var numRows:Int = 5
    var l=0, c=0
    var matrix: Matriz
    var pixelsDown: CGFloat?
    var orientacao: UIInterfaceOrientation
    

    init(frameW: CGFloat, frameH: CGFloat, orientacao: UIInterfaceOrientation, lesserExtent: CGFloat){
        
        frameWidth = Int(frameW)
        frameHeight = Int(frameH)
        circleRadius = Int(Double(lesserExtent) * 0.04)
        
        initialPointX = Int(Double(frameWidth) * 0.14)
        initialPointY = Int((Double(frameHeight) - ((Double(frameWidth) * 0.08) * 9.0))/2.0)
        
        matrix = Matriz(linhas: numRows, colunas: numColumns, circleRadius: circleRadius, initialPointX: initialPointX, initialPointY: initialPointY, orientacao: orientacao)
        
        self.orientacao = orientacao
        
        
    }

    func go2matrixPosition(l: Int, c: Int) {
        matrix.headNo.curr = matrix.headNo.first
        for _ in 0..<c{
             matrix.headNo.curr =  matrix.headNo.curr!.right!
        }
        for _ in 0..<l{
             matrix.headNo.curr =  matrix.headNo.curr!.down!
        }
    }
    func getL()->Int{
        return matrix.headNo.curr!.row
    }
    func getC()->Int{
        return matrix.headNo.curr!.col
    }
    
    func moveDotsDown(removeNodes: [No], removeNodesShapes: [Circulo]) -> ([No], [Circulo]){
        let firstDotNode: No
        let currCol: Int
        var positionsToGoDown = 0
        var dotFlag = -1
        var currDotRow: Int
        var currNodeCircle: Circulo
        var destinationNodeCircle: Circulo
        var destinationNodeShape: Shapes?
        var createDotAtRow :Int
        var removeNodesShapes = removeNodesShapes
        var removeNodes = removeNodes
        
        (removeNodesShapes, removeNodes) = sortNodes(removeNodes, removeNodesCirculo: removeNodesShapes)
        
        // Ver qual é o no corente nesse ponto
        //caso precise corrente na matriz ser igual ao removeNodes[0]
        go2matrixPosition2(removeNodes[0].row, c: removeNodes[0].col)
        currCol = removeNodes[0].col
        firstDotNode = removeNodes[0]
        currDotRow = firstDotNode.row
        
        while currDotRow >= 0{//comeca do nó mais embaixo que vai ser retirado ate a primeira linha
            while matrix.headNo.curr?.shape == nil && dotFlag != matrix.headNo.curr?.row{
                matrix.headNo.curr?.selected = true
                if matrix.headNo.curr?.up != nil{
                    matrix.headNo.curr = matrix.headNo.curr?.up
                }
                positionsToGoDown += 1
                dotFlag = currDotRow
                currDotRow -= 1
                
            }
            destinationNodeShape = returnMatrixPositionAt((matrix.headNo.curr?.row)! + positionsToGoDown,
                                                          c:(matrix.headNo.curr?.col)!).shape
            if positionsToGoDown > 0 && destinationNodeShape == nil && currDotRow >= 0{//caso a posicao de destino do no corrente for igual shape == nil
                for indexRemove in 0..<removeNodes.count{
                    if (matrix.headNo.curr?.row)! + positionsToGoDown == removeNodes[indexRemove].row &&
                        (matrix.headNo.curr?.col)! == removeNodes[indexRemove].col{
                        currNodeCircle = matrix.headNo.curr?.shape as! Circulo
                        destinationNodeCircle = removeNodesShapes[indexRemove]
                        let currY = currNodeCircle.initialPoint.y
                        let destinationY = destinationNodeCircle.lastPoint.y
                        currNodeCircle.inicialPointLandscape.x = destinationNodeCircle.lastPoint.y
                        currNodeCircle.lastPointLandscape.x = destinationNodeCircle.lastPoint.y
                        pixelsDown = CGFloat(currY) - CGFloat(destinationY)
                        currNodeCircle.initialPoint = destinationNodeCircle.lastPoint
                        currNodeCircle.row += positionsToGoDown
                        removeNodes[indexRemove].shape = matrix.headNo.curr?.shape
                    }
                }
                
            } else {
                if positionsToGoDown > 0 && destinationNodeShape != nil && currDotRow >= 0{ //caso a posicao de destino do no corrente for igual shape == nil
                    currNodeCircle = matrix.headNo.curr?.shape as! Circulo
                    destinationNodeCircle = destinationNodeShape as! Circulo
                    let currY = currNodeCircle.initialPoint.y
                    let destinationY = destinationNodeCircle.lastPoint.y
                    currNodeCircle.inicialPointLandscape.x = destinationNodeCircle.lastPoint.y
                    currNodeCircle.lastPointLandscape.x = destinationNodeCircle.lastPoint.y
                    pixelsDown = CGFloat(currY) - CGFloat(destinationY)
                    currNodeCircle.initialPoint = destinationNodeCircle.lastPoint
                    currNodeCircle.row += positionsToGoDown
                    returnMatrixPositionAt((matrix.headNo.curr?.row)! + positionsToGoDown, c: (matrix.headNo.curr?.col)!).shape = matrix.headNo.curr?.shape
                }
            }
            if (currDotRow) > 0{
                matrix.headNo.curr = matrix.headNo.curr?.up
            }
            currDotRow -= 1
        }
        //criar novos pontos
        createDotAtRow = positionsToGoDown - 1
        while createDotAtRow >= 0{
            go2matrixPosition2(createDotAtRow, c: currCol)
            matrix.headNo.curr?.shape = nil
           //matrix.headNo.curr?.shape = Circulo(row: createDotAtRow, col: currCol, circleOfRadius: CGFloat(circleRadius), initalPoint: CGPoint(x: CGFloat(initialPointX), y: CGFloat(initialPointY)), orientacao: orientacao)
            createDotAtRow -= 1
        }
        
        return (removeNodes, removeNodesShapes)
    }
    
    private func sortNodes(removeNodes: [No], removeNodesCirculo: [Circulo]) -> ([Circulo],[No]){
        var circulo: Circulo = removeNodesCirculo[0]
        var node: No = removeNodes[0]
        var removeNodesCirculoAux = removeNodesCirculo
        var removeNodesAux = removeNodes
        
        for _ in 0..<removeNodesCirculo.count-1{
            for index2 in 0..<removeNodesCirculo.count-1{
                if removeNodesCirculoAux[index2+1].row > removeNodesCirculoAux[index2].row{
                    node = removeNodesAux[index2]
                    circulo = removeNodesCirculoAux[index2]
                    
                    removeNodesCirculoAux[index2] = removeNodesCirculoAux[index2+1]
                    removeNodesAux[index2] = removeNodesAux[index2+1]
                    
                    removeNodesCirculoAux[index2+1] = circulo
                    removeNodesAux[index2+1] = node
                }
            }
        }
        return (removeNodesCirculoAux, removeNodesAux)
    }

    func tradeOrientationPoints(orientacao: UIInterfaceOrientation){
        var r = numRows - 1
        var c = numColumns - 1
        var curr: Circulo
        
        while r >= 0 {
            while c >= 0{
                go2matrixPosition2(r, c: c)
                curr = matrix.headNo.curr?.shape as! Circulo
                if orientacao.isPortrait{
                    curr.position = curr.initialPoint
                } else if orientacao.isLandscape{
                    curr.position = curr.inicialPointLandscape
                }
                c -= 1
            }//end while c>=0
            c = numColumns - 1
            r -= 1
        }//end while r>=0
        
    }
    
    
    func go2matrixPosition2(r: Int, c: Int) {
        let currRow = matrix.headNo.curr?.row
        let currCol = matrix.headNo.curr?.col
        
        let finishRow = r - currRow!
        let finishCol = c - currCol!
        //move coluna corrente
        if finishCol > 0{
            for _ in 0..<finishCol{
                matrix.headNo.curr =  matrix.headNo.curr!.right!
            }
        }
        else if finishCol < 0{
            for _ in finishCol..<0{
                matrix.headNo.curr =  matrix.headNo.curr!.left!
            }
        }
        //mover linha corrente
        if finishRow > 0{
            for _ in 0..<finishRow{
                matrix.headNo.curr =  matrix.headNo.curr!.down!
            }
        }
        else if finishRow < 0{
            for _ in finishRow..<0{
                matrix.headNo.curr =  matrix.headNo.curr!.up!
            }
        }
        
    }
    
    //nao altera posicao do no corrente da cabeca da matriz
    func returnMatrixPositionAt(r: Int, c: Int) -> No {
        let currRow = matrix.headNo.curr?.row
        let currCol = matrix.headNo.curr?.col
        var currNode = matrix.headNo.curr
        
        let finishRow = r - currRow!
        let finishCol = c - currCol!
        //move coluna corrente
        if finishCol > 0{
            for _ in 0..<finishCol{
                currNode =  currNode!.right!
            }
        }
        else if finishCol < 0{
            for _ in finishCol..<0{
                currNode =  currNode!.left!
            }
        }
        //mover linha corrente
        if finishRow > 0{
            for _ in 0..<finishRow{
                currNode =  currNode!.down!
            }
        }
        else if finishRow < 0{
            for _ in finishRow..<0{
                currNode =  currNode!.up!
            }
        }
        return currNode!
    }
    
    
    
    
    
    func moveDotsDownLandscape(removeNodes: [No], removeNodesShapes: [Circulo]) -> ([No], [Circulo]){
        let firstDotNode: No
        var currCol: Int
        var positionsToGoDown = 0
        var dotFlag = -1 //ve se ja passou pro essa linha
        var currDotRow: Int
        var currNodeCircle: Circulo
        var destinationNodeCircle: Circulo
        var destinationNodeShape: Shapes?
        var createDotAtCol :Int
        var removeNodesShapes = removeNodesShapes
        var removeNodes = removeNodes
        
        (removeNodesShapes, removeNodes) = sortNodesLandscape(removeNodes, removeNodesCirculo: removeNodesShapes)
        
        // Ver qual é o no corente nesse ponto
        //caso precise corrente na matriz ser igual ao removeNodes[0]
        go2matrixPosition2(removeNodes[0].row, c: removeNodes[0].col)
        currCol = removeNodes[0].col
        firstDotNode = removeNodes[0]
        currDotRow = firstDotNode.row
        
        while currCol >= 0{//comeca do nó mais embaixo que vai ser retirado ate a primeira linha(que é a primeira coluna)
            while matrix.headNo.curr?.shape == nil && dotFlag != matrix.headNo.curr?.col && currCol >= 0{
                matrix.headNo.curr?.selected = true
                if matrix.headNo.curr?.left != nil{
                    matrix.headNo.curr = matrix.headNo.curr?.left
                }
                positionsToGoDown += 1
                dotFlag = currCol
                currCol -= 1
                
            }
            destinationNodeShape = returnMatrixPositionAt((matrix.headNo.curr?.row)! ,c:(matrix.headNo.curr?.col)! + positionsToGoDown).shape
            if positionsToGoDown > 0 && destinationNodeShape == nil && currCol >= 0{//caso a posicao de destino do no corrente for igual shape == nil
                for indexRemove in 0..<removeNodes.count{
                    if (matrix.headNo.curr?.col)! + positionsToGoDown == removeNodes[indexRemove].col &&
                        (matrix.headNo.curr?.row)! == removeNodes[indexRemove].row{
                        currNodeCircle = matrix.headNo.curr?.shape as! Circulo
                        destinationNodeCircle = removeNodesShapes[indexRemove]
                        let currY = currNodeCircle.inicialPointLandscape.y
                        let destinationY = destinationNodeCircle.lastPointLandscape.y
                        //currNodeCircle.initialPoint.x = destinationNodeCircle.lastPointLandscape.y
                        pixelsDown = CGFloat(currY) - CGFloat(destinationY)
                        currNodeCircle.initialPoint.x += pixelsDown!
                        currNodeCircle.lastPoint.x += pixelsDown!
                        currNodeCircle.inicialPointLandscape = destinationNodeCircle.lastPointLandscape
                        currNodeCircle.col += positionsToGoDown
                        removeNodes[indexRemove].shape = matrix.headNo.curr?.shape
                    }
                }
                
            } else {
                if positionsToGoDown > 0 && destinationNodeShape != nil && currCol >= 0{ //caso a posicao de destino do no corrente for igual shape != nil
                    currNodeCircle = matrix.headNo.curr?.shape as! Circulo
                    destinationNodeCircle = destinationNodeShape as! Circulo
                    let currY = currNodeCircle.inicialPointLandscape.y
                    let destinationY = destinationNodeCircle.lastPointLandscape.y
                    //currNodeCircle.initialPoint.x = destinationNodeCircle.inicialPointLandscape.y
                    pixelsDown = CGFloat(currY) - CGFloat(destinationY)
                    currNodeCircle.initialPoint.x += pixelsDown!
                    currNodeCircle.lastPoint.x += pixelsDown!
                    currNodeCircle.inicialPointLandscape = destinationNodeCircle.lastPointLandscape
                    currNodeCircle.col += positionsToGoDown
                    returnMatrixPositionAt((matrix.headNo.curr?.row)!, c: (matrix.headNo.curr?.col)! + positionsToGoDown).shape = matrix.headNo.curr?.shape
                }
            }
            if (currCol) > 0{
                matrix.headNo.curr = matrix.headNo.curr?.left
            }
            currCol -= 1
        }
        //criar novos pontos
        createDotAtCol = positionsToGoDown - 1
        while createDotAtCol >= 0{
            go2matrixPosition2(currDotRow, c: createDotAtCol)
            matrix.headNo.curr?.shape = nil
            //matrix.headNo.curr?.shape = Circulo(row: createDotAtRow, col: currCol, circleOfRadius: CGFloat(circleRadius), initalPoint: CGPoint(x: CGFloat(initialPointX), y: CGFloat(initialPointY)), orientacao: orientacao)
            createDotAtCol -= 1
        }
        
        return (removeNodes, removeNodesShapes)
    }

    private func sortNodesLandscape(removeNodes: [No], removeNodesCirculo: [Circulo]) -> ([Circulo],[No]){
        var circulo: Circulo = removeNodesCirculo[0]
        var node: No = removeNodes[0]
        var removeNodesCirculoAux = removeNodesCirculo
        var removeNodesAux = removeNodes
        
        for _ in 0..<removeNodesCirculo.count-1{
            for index2 in 0..<removeNodesCirculo.count-1{
                if removeNodesCirculoAux[index2+1].col > removeNodesCirculoAux[index2].col{
                    node = removeNodesAux[index2]
                    circulo = removeNodesCirculoAux[index2]
                    
                    removeNodesCirculoAux[index2] = removeNodesCirculoAux[index2+1]
                    removeNodesAux[index2] = removeNodesAux[index2+1]
                    
                    removeNodesCirculoAux[index2+1] = circulo
                    removeNodesAux[index2+1] = node
                }
            }
        }
        return (removeNodesCirculoAux, removeNodesAux)
    }
    
}