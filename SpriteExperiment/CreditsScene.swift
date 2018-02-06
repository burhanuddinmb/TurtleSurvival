//
//  CreditsScene.swift
//  TurtleSurvival
//
//  Created by student on 10/15/17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation

import SpriteKit

class CreditsScene: SKScene {
    
    override func didMove(to view: SKView)
    {
        let backgroundMusic = SKAudioNode(fileNamed: "Game-Menu_Looping.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self);
            
            if atPoint(location).name == "Home"
            {
                if let scene = HomeScene(fileNamed: "MainMenu")
                {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene)
                }
            }
        }
        
    }
}
