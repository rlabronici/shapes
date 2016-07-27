//
//  FrameScene.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 14/04/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//
//
import SpriteKit
import UIKit

class FrameScene: SKScene{
    
    var mapa:  Mapa
    var node: Circulo?
    var menorMedida: CGFloat
    var ref: CGMutablePath?
    var circleRadius: CGFloat
    var lineStroke: CGFloat
    var removeNodes = [No]()
    var removeNodesShapes = [Circulo]()
    var line = [SKShapeNode]()
    var pointsLabel: SKLabelNode
    let vc = UIViewController()
    var orientacao :UIInterfaceOrientation
    var countPoints: Int = 0
    var movesLabel: SKLabelNode
    var countMoves: Int = 20
    var frameHeight:CGFloat
    var frameWidth:CGFloat
    //var ori = UIApplication.sharedApplication().statusBarOrientation
    
    init(size:CGSize, frameWidth: CGFloat, frameHeight: CGFloat, orientacao: UIInterfaceOrientation){
        self.orientacao = UIApplication.sharedApplication().statusBarOrientation
        //print(ori.isLandscape)
        if frameHeight < frameWidth{
            menorMedida = frameHeight
        }else{
            menorMedida = frameWidth
        }
        
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        mapa = Mapa(frameW: frameWidth, frameH: frameHeight, orientacao: orientacao, lesserExtent: menorMedida)
        print(frameHeight)
        print(frameWidth)
        circleRadius = menorMedida * 0.04
        lineStroke = 2 * circleRadius / 3
        
        pointsLabel = SKLabelNode(fontNamed:"Arial")
        pointsLabel.text = "Points: \(countPoints)"
        pointsLabel.fontColor = UIColor.blackColor()
        pointsLabel.fontSize = 22
        pointsLabel.position = CGPoint(x:100, y:100)

        movesLabel = SKLabelNode(fontNamed:"Arial")
        movesLabel.text = "Moves: \(countMoves)"
        movesLabel.fontColor = UIColor.blackColor()
        movesLabel.fontSize = 22
        if orientacao.isPortrait{
            movesLabel.position = CGPoint(x:100, y:600)
        } else {
            movesLabel.position = CGPoint(x:600, y:100)
        }

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        addChild(pointsLabel)
        addChild(movesLabel)
        drawDots()

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            let nodeAux = nodeTouched as? Shapes
            if nodeAux is Circulo {
                node = nodeTouched as? Circulo
                if node?.blocked == false{
                    ref = CGPathCreateMutable()
                    CGPathMoveToPoint(ref, nil, (node?.position.x)! + circleRadius, (node?.position.y)! + circleRadius)
                    mapa.go2matrixPosition((node?.row)!, c: (node?.col)!)
                    print("linha.no: \(mapa.getL())")
                    print("col.no: \(mapa.getC())")
                }
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            let nodeNeighbor = nodeTouched as? Shapes
            if nodeNeighbor is Circulo{
                let nodeNeighbor2 = nodeTouched as! Circulo
                if nodeNeighbor2.blocked == false{
                    if nodeNeighbor2.getColorStr() == node?.getColorStr() && node != nodeNeighbor2 && isNeighbor(nodeNeighbor2) && !isFather(nodeNeighbor2){
                        print("moves")
                        drawLine(nodeNeighbor2)
                        if !hasCycle(nodeNeighbor2){
                            if removeNodes.count == 0{
                                removeNodes.append(mapa.returnMatrixPositionAt(node!.row, c: node!.col))
                                removeNodes[removeNodes.count-1].selected = true
                                removeNodesShapes.append(node!)
                            }
                            node = nodeNeighbor2
                            removeNodesShapes.append(node!)
                            removeNodes.append(mapa.returnMatrixPositionAt(node!.row, c: node!.col))
                            removeNodes[removeNodes.count-1].selected = true
                            mapa.go2matrixPosition(node!.getRow(), c: node!.getCol())
                        } else if nodeNeighbor2.cycle == false{
                            //tem ciclo
                            nodeNeighbor2.cycle = true
                            searchAllDotsByColor(nodeNeighbor2)
                        }
                    }
                }
            }
        }
   }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if removeNodes.count >= 2{
            removeFromScene()
            countMoves -= 1
            movesLabel.text = "Moves: \(countMoves)"
            if countMoves == 0{
                self.removeAllChildren()
                goToGameScene()
            }

        }

       
    }
    private func goToGameScene(){
        let gameScene = GameScene()
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    override func update(currentTime: NSTimeInterval) {
        var nodeAux: Circulo
        var r = mapa.numRows - 1
        var c = mapa.numColumns - 1

        verifyScreen()
        while r >= 0 {
            while c >= 0{
                mapa.go2matrixPosition2(r, c: c)
                if mapa.matrix.headNo.curr?.shape != nil{
                    nodeAux = mapa.matrix.headNo.curr?.shape as! Circulo
                    if orientacao.isPortrait{
                        
                        if nodeAux.position != nodeAux.initialPoint {
                            nodeAux.position.y -= (mapa.pixelsDown! * 0.1)
                            if nodeAux.position == nodeAux.initialPoint{
                                nodeAux.lastPoint = nodeAux.initialPoint
                            }
                        }
                        if nodeAux.position.y < nodeAux.initialPoint.y {
                            nodeAux.position = nodeAux.initialPoint
                        }
                        
                    } else if orientacao.isLandscape{
                        
                        if nodeAux.position != nodeAux.inicialPointLandscape{
                            nodeAux.position.y -= (mapa.pixelsDown! * 0.1)
                            if nodeAux.position == nodeAux.inicialPointLandscape{
                                nodeAux.lastPointLandscape = nodeAux.inicialPointLandscape
                            }
                        }//end if nodeAux.position != nodeAux.inicialPointLandscape
                        if nodeAux.position.y < nodeAux.inicialPointLandscape.y{
                            nodeAux.position = nodeAux.inicialPointLandscape
                        }
                    }//else if orientacao.isLandscape
                }//end if mapa.matrix.headNo.curr?.shape != nil
                else{
                    
                    mapa.matrix.headNo.curr?.shape = Circulo(row: r, col: c, circleOfRadius: CGFloat(circleRadius),
                                                             initalPoint: CGPoint(x: CGFloat(mapa.initialPointX),
                                                                y: CGFloat(mapa.initialPointY)),
                                                             orientacao: orientacao)
                    nodeAux = mapa.matrix.headNo.curr?.shape as! Circulo
                    addChild(nodeAux)
                    pointsLabel.text = "Points: \(countPoints)"
                    while !hasMoviment(){
                        restartDots()
                    }
                }//end else | if mapa.matrix.headNo.curr?.shape != nil
                c -= 1
            }//end while c>=0
            c = mapa.numColumns - 1
            r -= 1
        }//end while r>=0
        self.orientacao = UIApplication.sharedApplication().statusBarOrientation
        if mapa.returnMatrixPositionAt(4, c: 0).shape != nil && orientacao.isPortrait{
            while hasBlockedDotsInLastLine(){
                verifyBlockedDots()
                removeFromScene()
            }
        }
    }
    
    private func drawDots(){
        var l=0, c=0
        while l < 5{
            while c < 5{
                mapa.go2matrixPosition2( l, c: c)
                self.addChild(mapa.matrix.headNo.curr!.shape as! SKShapeNode)
                c += 1
            }
            l += 1
            c = 0
        }
    }
    
    func isNeighbor(nodeNeighbor: Circulo) -> Bool{
        if nodeNeighbor.getRow()+1 == node?.getRow() && nodeNeighbor.getCol() == node?.getCol(){
            return true
        }else if nodeNeighbor.getRow() == node?.getRow() && nodeNeighbor.getCol()+1 == node?.getCol(){
            return true
        }else if nodeNeighbor.getRow() == node?.getRow() && nodeNeighbor.getCol()-1 == node?.getCol(){
            return true
        }else if nodeNeighbor.getRow()-1 == node?.getRow() && nodeNeighbor.getCol() == node?.getCol(){
            return true
        }
        return false
    }
    
    func isFather(currCircle: Circulo) -> Bool{
        let currNode = mapa.returnMatrixPositionAt(currCircle.row, c: currCircle.col)
        if removeNodes.count >= 2 && currNode === removeNodes[removeNodes.count-2]{
                return true
            }
        return false
    }
    
    func drawLine(nodeN: Circulo){
        let lineAux = SKShapeNode()
        //CGPathAddLineToPoint(ref, nil, nodeN.initialPoint.x + circleRadius, nodeN.initialPoint.y + circleRadius)
        CGPathAddLineToPoint(ref, nil, nodeN.position.x + circleRadius, nodeN.position.y + circleRadius)
        lineAux.path = ref
        lineAux.lineWidth = CGFloat(lineStroke)
        lineAux.strokeColor = nodeN.colorRGB.colorWithAlphaComponent(1)
        self.addChild(lineAux)
        line.append(lineAux)
    }
    func removeFromScene(){
        countPoints += removeNodes.count
        for index in 0..<removeNodes.count{
            mapa.go2matrixPosition2(removeNodes[index].row, c: removeNodes[index].col)
            mapa.matrix.headNo.curr?.selected = false
            let circuloCurr = mapa.matrix.headNo.curr?.shape as! Circulo
            circuloCurr.removeFromParent()
            mapa.matrix.headNo.curr?.shape = nil
        }
        //self.removeChildrenInArray(removeNodesShapes)
        while removeNodes.count != 0{
            //remover da matriz
            mapa.go2matrixPosition2(removeNodes[0].row, c: removeNodes[0].col)
            if mapa.matrix.headNo.curr?.selected == false {
                if orientacao.isPortrait{
                    (removeNodes, removeNodesShapes) = mapa.moveDotsDown(removeNodes, removeNodesShapes: removeNodesShapes)
                } else if orientacao.isLandscape{
                    (removeNodes, removeNodesShapes) = mapa.moveDotsDownLandscape(removeNodes, removeNodesShapes: removeNodesShapes)
                }
            }
            
            mapa.returnMatrixPositionAt(removeNodes[0].row, c: removeNodes[0].col).selected = false
            
            removeNodesShapes.removeFirst()
            removeNodes.removeFirst()
        }
        

        
        while line.count != 0 {
            self.removeChildrenInArray(line)
            line.removeLast()
        }
        ref = nil
    }
    func verifyScreen(){
        orientacao = UIApplication.sharedApplication().statusBarOrientation
        //verifica orientacao
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if orientacao.isLandscape{
            if self.size.height > self.size.width{
                //trocar altura e largura
                self.size.height = screenHeight
                self.size.width = screenWidth
                circleRadius = menorMedida * 0.04
                movesLabel.position = CGPoint(x:600, y:100)
                // trocar posicao x por y
                mapa.tradeOrientationPoints(orientacao)
            }
        } else if orientacao.isPortrait{
            if self.size.height < self.size.width{
                //trocar altura e largura
                self.size.height = screenHeight
                self.size.width = screenWidth
                circleRadius = menorMedida * 0.04
                movesLabel.position = CGPoint(x:100, y:600)
                // trocar posicao x por y
                mapa.tradeOrientationPoints(orientacao)
            }
        }
    }
    func hasCycle(currCircle: Circulo) -> Bool{
        let currNode = mapa.returnMatrixPositionAt(currCircle.row, c: currCircle.col)
        if currNode.selected{
            return true
        }
        return false
    }
    func searchAllDotsByColor(currCircle: Circulo){
        let memory = mapa.matrix.headNo.curr
        for row in 0..<mapa.numRows{
            for col in 0..<mapa.numColumns{
                mapa.go2matrixPosition2(row, c: col)
                if mapa.matrix.headNo.curr?.selected == false{
                    let circle = mapa.matrix.headNo.curr?.shape as! Circulo
                    if circle.colorRGB == currCircle.colorRGB{
                        removeNodes.append(mapa.returnMatrixPositionAt(circle.row, c: circle.col))
                        removeNodesShapes.append(circle)
                    }
                    
                }
            }
        }
        mapa.matrix.headNo.curr = memory
    }
    
    func verifyBlockedDots(){
        var blockedCircle: Circulo
        for col in 0..<mapa.numColumns{
            mapa.go2matrixPosition(4, c: col)
            blockedCircle = mapa.matrix.headNo.curr?.shape as! Circulo
            if blockedCircle.isBlocked() && blockedCircle.lastPoint == blockedCircle.initialPoint{
                // deletar o ponto bloqueado
                removeNodesShapes.append(blockedCircle)
                removeNodes.append(mapa.matrix.headNo.curr!)
            }
        }
    }
    func hasBlockedDotsInLastLine()->Bool{
        var blockedCircle: Circulo
        for col in 0..<mapa.numColumns{
            mapa.go2matrixPosition(4, c: col)
            blockedCircle = mapa.matrix.headNo.curr?.shape as! Circulo
            if blockedCircle.isBlocked() && blockedCircle.lastPoint == blockedCircle.initialPoint{
                // deletar o ponto bloqueado
                return true
            }
        }
        return false
    }
    func hasMoviment()->Bool{
        var curr: No
        var currCircle: Circulo
        var nextCircle: Circulo
        
        for r in 0..<mapa.numRows-1{
            for c in 0..<mapa.numColumns-1{
                curr = mapa.returnMatrixPositionAt(r, c: c)
                if curr.shape != nil && curr.right?.shape != nil && curr.down?.shape != nil{
                    currCircle = curr.shape as! Circulo
                    nextCircle = curr.down?.shape as! Circulo
                    if currCircle.colorStr != "black"{
                        if currCircle.colorStr == nextCircle.colorStr{
                            return true
                        }
                    }
                    nextCircle = curr.right?.shape as! Circulo
                    if currCircle.colorStr != "black"{
                        if currCircle.colorStr == nextCircle.colorStr{
                            return true
                        }
                    }
                }else{
                    return true
                }
            }
        }
        return false
    }
    func restartDots(){
        //self.orientacao = UIApplication.sharedApplication().statusBarOrientation
        var curr: No
        for r in 0..<mapa.numRows{
            for c in 0..<mapa.numColumns{
                curr = mapa.returnMatrixPositionAt(r, c: c)
                let currCir = curr.shape as! Circulo
                currCir.removeFromParent()
                curr.shape = nil
                
            }
        }
    }
}
