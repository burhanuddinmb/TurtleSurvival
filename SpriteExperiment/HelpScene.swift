//
//  HelpScene.swift
//  TurtleSurvival
//
//  Created by NandhiniSathish on 11/10/17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation

import SpriteKit

class HelpScene: SKScene {
    
    override func didMove(to view: SKView)
    {
        //Background music for the HelpScene
        let backgroundMusic = SKAudioNode(fileNamed: "Game-Menu_Looping.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            //Button for main menu
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
