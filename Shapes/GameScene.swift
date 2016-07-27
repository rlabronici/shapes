//
//  GameScene.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 12/04/16.
//  Copyright (c) 2016 Rodrigo Labronici. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    let button   = UIButton(type: UIButtonType.Custom) as UIButton
    let vc = UIViewController()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(red: 1, green:1, blue:1, alpha: 1.0)
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        //if orientation.isPortrait
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        //let screenWidth =
        //let screenHeight =
        if orientation.isPortrait{
            self.size.height = screenSize.height
            self.size.width = screenSize.width
        }else{
            self.size.height = screenSize.width
            self.size.width = screenSize.height
        }
        
        let title = SKLabelNode(fontNamed:"Arial")
        title.text = "Shapes project"
        title.fontColor = UIColor.blackColor()
        title.fontSize = 45
        title.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-100)
        
        let description = SKLabelNode(fontNamed:"Arial")
        description.text = "Choose the game mode"
        description.fontColor = UIColor.blackColor()
        description.fontSize = 20
        description.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-300)
        
        /*let buttonPoints = SKSpriteNode(imageNamed: "points.png")
        buttonPoints.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        buttonPoints.name = "points"*/
 
        let image = UIImage(named: "points.png") as UIImage?
        if orientation.isPortrait{
            button.frame = CGRectMake((self.size.width - image!.size.width)/2, 310, image!.size.width, image!.size.height)
        }else{
            button.frame = CGRectMake((self.size.height - image!.size.width)/2, 300, image!.size.width, image!.size.height)
        }
        //button.frame = CGRectMake((screenWidth - image!.size.width)/2, 310, image!.size.width, image!.size.height)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: #selector(GameScene.goToFrameScene(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.view!.addSubview(button)
        
        self.addChild(title)
        self.addChild(description)
        //self.addChild(buttonPoints)
    }
    
    func goToFrameScene(sender:UIButton!)
    {
        self.button.removeFromSuperview()
        //let vc = UIViewController()
        let orietacao = UIApplication.sharedApplication().statusBarOrientation
        let fScene = FrameScene(size: self.size, frameWidth: self.size.width, frameHeight: self.size.height, orientacao: orietacao)
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        fScene.scaleMode = SKSceneScaleMode.AspectFill
        self.removeAllChildren()
        self.scene!.view?.presentScene(fScene, transition: transition)
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       
//    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
