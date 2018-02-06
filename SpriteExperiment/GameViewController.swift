//
//  GameViewController.swift
//  SpriteExperiment
//
//  Created by Student on 9/11/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //let button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
        
       //let scene = GameScene(size: view.bounds.size)
        
        if let scene = HomeScene(fileNamed: "MainMenu")
        {
        
        
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        }
         view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
       
        }
    }
    
    

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
