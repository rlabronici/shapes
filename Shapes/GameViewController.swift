//
//  GameViewController.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 12/04/16.
//  Copyright (c) 2016 Rodrigo Labronici. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var orientacao = UIInterfaceOrientation.Unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            orientacao = UIInterfaceOrientation.LandscapeRight
        } else {
            orientacao = UIInterfaceOrientation.Portrait
        }
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            print("landscape")
            orientacao = UIInterfaceOrientation.LandscapeRight
        } else {
            print("portrait")
            orientacao = UIInterfaceOrientation.Portrait
        }
    }
}
