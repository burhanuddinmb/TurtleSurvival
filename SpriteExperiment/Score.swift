//
//  Score.swift
//  TurtleSurvival
//
//  Created by student on 10/14/17.
//  Copyright © 2017 Student. All rights reserved.
//
import Foundation

//To save the score.
class Score{
    //Used per level. Resets every game
    static var levelTime:Double = 0

    let storeBestKey = "storeBestKey"
    static let sharedData = Score() // 1 - single instance is a class variable
    var allTimeBest:Double = 0 {
        didSet{
            //Store value in memory
            let defaults = UserDefaults.standard
            defaults.set(allTimeBest, forKey: storeBestKey)
        }
    }
    
    private init(){ // 2 - private initializer can't be called from "outside"
        readDefaultsData()
        print("Created Score instance")
    }

    //Fetch falue from memory
    private func readDefaultsData(){
        let defaults = UserDefaults.standard
        allTimeBest = defaults.double(forKey: storeBestKey)
    }
}
