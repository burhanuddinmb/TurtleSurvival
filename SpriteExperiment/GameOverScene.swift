//
//  GameOverScene.swift
//  SpriteExperiment
//
//  Created by Student on 9/11/17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {

    override func didMove(to view: SKView)
    {
        //Play background Music
        let gameOverMusic = SKAudioNode(fileNamed: "GameOver.wav")
        gameOverMusic.autoplayLooped = true
        addChild(gameOverMusic)
        
        //Display the score in the GameOver screen
        var scoreValue:String!
        
        //Score for the current run
        let thisRunScore:SKLabelNode = SKLabelNode(fontNamed: "Zekton")
        scoreValue = String(format: "%.1f", Score.levelTime)
        thisRunScore.fontSize = 50
        thisRunScore.alpha = 1
        thisRunScore.fontColor = SKColor.white
        thisRunScore.zPosition = visualPosition.Score
        thisRunScore.position = CGPoint(x: 5 , y: 90)
        thisRunScore.text = scoreValue + "s"
        addChild(thisRunScore)
        
        //All time best score
        let bestRunScore:SKLabelNode = SKLabelNode(fontNamed: "Zekton")
        scoreValue = String(format: "%.1f", Score.sharedData.allTimeBest)
        bestRunScore.fontSize = 50
        bestRunScore.alpha = 1
        bestRunScore.fontColor = SKColor.white
        bestRunScore.zPosition = visualPosition.Score
        bestRunScore.position = CGPoint(x: 5 , y: -140)
        bestRunScore.text = scoreValue + "s"
        addChild(bestRunScore)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            //Button for MainMenu
            let location = touch.location(in: self);
            if atPoint(location).name == "Gameover"
            {
                if let scene = HomeScene(fileNamed: "MainMenu")
                {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene)//, transition: SKTransition.doorsOpenVertical(withDuration: 2))
                }
            }
        }

    }
}
