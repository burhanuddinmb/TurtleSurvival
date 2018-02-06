//
//  HomeScene.swift
//  SpriteExperiment
//
//  Created by NandhiniSathish on 24/09/17.
//  Copyright © 2017 Student. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self);
            
            //Button for Start game
            if atPoint(location).name == "Play"
            {
                if let scene = GameScene(fileNamed: "GamePlayScene")
                {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene, transition: SKTransition.doorway(withDuration: 2))
                }
            }
            //Button for Instructions
            if atPoint(location).name == "Help"
            {
                if let scene = HelpScene(fileNamed: "HelpMenuScene")
                {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene)//, transition: SKTransition.doorway(withDuration: 2))
                }
            }
            if atPoint(location).name == "Credits"
            {
                if let scene = HelpScene(fileNamed: "CreditsScene")
                {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene)//, transition: SKTransition.doorway(withDuration: 2))
                }
            }
        }
    }
    
    override func didMove(to view: SKView)
    {
        //Background music
        let HomeMusic = SKAudioNode(fileNamed: "Game-Menu_Looping.mp3")
        HomeMusic.autoplayLooped = true
        addChild(HomeMusic)
        
        //Best time display
        let bestTime:SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
        print(bestTime.fontName!)
        var scoreValue:String!
        scoreValue = String(format: "%.1f", Score.sharedData.allTimeBest)
        bestTime.fontSize = 80
        bestTime.alpha = 1
        bestTime.fontColor = SKColor.white
        bestTime.zPosition = visualPosition.Score
        bestTime.position = CGPoint(x: -90 , y: -(scene!.size.height/2) + 94)
        bestTime.text = scoreValue + "s"
        addChild(bestTime)
        
        // Just an emitter node for visuals
        if let particles = SKEmitterNode(fileNamed: "SparkEffect.sks")
        {
            particles.position = CGPoint(x: scene!.size.width * 0.22, y: scene!.size.height * 0.37)
            addChild(particles)
        }
    }
    
}
