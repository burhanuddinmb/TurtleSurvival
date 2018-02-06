//
//  GameScene.swift
//  SpriteExperiment
//
//  Created by Student on 9/11/17.
//  Copyright © 2017 Student. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate
{
    //Mark: - Variable Declarations -
    
    // Sprite Nodes
    var life: [SKSpriteNode]! = [] //Life bar
    var player: SKSpriteNode! // Player Object
    
    //Player animations
    var playerShootingFrames: [SKTexture]!
    var shootingFrames = [SKTexture]()

    var projectilePresent = false //To control the arrows shot
    var playerUp = false //To know if player is still inbetween jump

    var score = SKLabelNode() //Score label
    var timer = Timer() //Timer for iterative difficulty and enemy generation
    
    //For increasing difficulty as time goes by
    var speedOfGeneration:Double = 1.2
    {
        //Cap generation speed
        didSet{
            if speedOfGeneration < 0.4{
                speedOfGeneration = 0.4
            }
        }
    }
    
    //Control enemy generation in the update loop
    var generateEnemies:Bool = false
    
    //Counter to determine if speed needs to be increased
    var counterForSpeedIncrement = 0
    
    override func didMove(to view: SKView)
    {
        //MARK: - Scrolling Background -
        createBackground()
        
        //MARK: - Background Music -
        let backgroundMusic = SKAudioNode(fileNamed: "Lost-Jungle_Looping.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //MARK: - Physics World -
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self

        //MARK: - Score -
        score = SKLabelNode(fontNamed: "Zekton")
        Score.levelTime = 0.0
        //To increment score everysecond
        //This iteration was better when compared to the timer
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run(changeScore)
                ])
        ))
        score.fontSize = 50
        score.alpha = 0.7
        score.fontColor = SKColor.white
        score.zPosition = visualPosition.Score
        score.position = CGPoint(x: size.width / 8 , y: size.height / 80)
        addChild(score)
        
        
        //MARK: - Avatar Animations -
        let playerAnimatedAtlas: SKTextureAtlas = SKTextureAtlas(named: "PlayerImages")
        let numImages = playerAnimatedAtlas.textureNames.count
        
        //Load the player animation frames from the TextureAtlas
        for i in 1...numImages
        {
            shootingFrames.append(playerAnimatedAtlas.textureNamed("player\(i)"))
        }
        
        playerShootingFrames = shootingFrames
        
        //Setup Player
        let temp: SKTexture = playerShootingFrames[0]
        player = SKSpriteNode(texture: temp)
        player.position = CGPoint(x: size.width * 0.1 , y: 295)
        player.physicsBody = SKPhysicsBody(texture: player.texture!,
                                                       size: player.texture!.size())
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
        
        //MARK: - Setting up life -
        var lifeActualX = size.width * 0.1
        for i in 0...4
        {
             let lifeObject = SKSpriteNode(imageNamed: "Life")
             lifeObject.setScale(1.2)
             lifeObject.position = CGPoint(x: lifeActualX, y: 970)
             life.append(lifeObject)
             addChild(life[i])
             lifeActualX += lifeObject.size.width*1.2
        }
        
        //MARK: - Timer to generate enemies and increase difficulty -
        timer = Timer.scheduledTimer(timeInterval: speedOfGeneration, target: self, selector: #selector(controlTiming), userInfo: nil, repeats: true)
        
        //Generate the rocks
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addRockCollider),
                SKAction.wait(forDuration: 3)
                ])
        ))
    }
    
    //MARK: - Functions related to Background -
    
    //Create Background
    func createBackground()
    {
        for i in 0...3
        {
            let backGround = SKSpriteNode(imageNamed: "ground")
            backGround.name = "Ground"
            backGround.size = CGSize(width: (self.scene?.size.width)!, height: 190)
            backGround.anchorPoint = CGPoint(x: 0, y: 0)
            backGround.position = CGPoint(x: CGFloat(i) * backGround.size.width, y: 0)
            backGround.zPosition = visualPosition.Ground
            self.addChild(backGround)
        }
    }

    //Make the grounds move left
    func moveGrounds()
    {
        self.enumerateChildNodes(withName: "Ground", using: ({
            
            (node, error) in
            
            node.position.x -= 2
            
            if node.position.x < -(self.scene?.size.width)!
            {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    //MARK: - Change the display score -
    func changeScore()
    {
        Score.levelTime = Score.levelTime + 0.1
        let scoreValue:String = String(format: "%.1f", Score.levelTime)
        score.text = "Time: " + scoreValue + "s"
    }
    
    //MARK: - Increments difficulty as time goes by -
    func controlTiming() {
        generateEnemies = true
        counterForSpeedIncrement += 1
        if counterForSpeedIncrement > 20{
            counterForSpeedIncrement = 0
            speedOfGeneration -= 0.1
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: speedOfGeneration, target: self, selector: #selector(controlTiming), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - Functions related to Enemies -
    
    //Make enemies depending on the random number
    func makeEnemies() {
        let enemy = (randomInt(min: 0, max: 3)) % 3
 
        switch (enemy){
            case 0: addRat()
            
            case 1: addBee()
            
            case 2: beeMovingTowardsYou()
            
            default: print("Invalid state")
        }

    }
    
    //Rock collider sprite creation and actions
    func addRockCollider()
    {
        let actualY: CGFloat = 210
        let actualDuration: CGFloat = 2.5
        let nodePos = CGPoint(x: size.width + #imageLiteral(resourceName: "rockCollider").size.width, y: actualY)
        let node = ObjectCollider(imageNamed: "rockCollider", name: "rockObject", position: nodePos, color: UIColor.brown, blendFactor: 0.7, categoryMask: PhysicsCategory.Monster, contactMask: PhysicsCategory.Projectile, zPosition: visualPosition.Rock)
        addChild(node)
        
        let actionMove = SKAction.move(to: CGPoint(x: -(#imageLiteral(resourceName: "rockCollider").size.width/2), y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        node.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //Rat sprite creation and actions
    func addRat()
    {
        let actualY: CGFloat = 235
        let actualDuration: CGFloat = 4
        
        let nodePos = CGPoint(x: size.width + #imageLiteral(resourceName: "Rat").size.width, y: actualY)
        let node = ObjectCollider(imageNamed: "Rat", name: "ratObject", position: nodePos, color: UIColor.black, blendFactor: 0.3, categoryMask: PhysicsCategory.Monster, contactMask: PhysicsCategory.Projectile, zPosition: visualPosition.Enemy)
        addChild(node)
        
        let actionMove = SKAction.move(to: CGPoint(x: -(#imageLiteral(resourceName: "Rat").size.width/2), y: actualY), duration: TimeInterval(actualDuration))       //texturedMonster.size.width/2
        let actionMoveDone = SKAction.removeFromParent()
        node.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //BeeIdle sprite creation and actions
    func addBee()
    {
        let actualY:CGFloat = 600
        let nodePos = CGPoint(x: size.width + #imageLiteral(resourceName: "BeeIdle").size.width, y: actualY)
        let node = ObjectCollider(imageNamed: "BeeIdle", name: "BeeIdleObject", position: nodePos, color: UIColor.white, blendFactor: 0.3, categoryMask: PhysicsCategory.Monster, contactMask: PhysicsCategory.Projectile, zPosition: visualPosition.Enemy)
        addChild(node)
     
        let actualDuration:CGFloat = 4.0
        
        //BeeIdle move actions
        let actionMove1 = SKAction.move(to: CGPoint(x: -(#imageLiteral(resourceName: "BeeIdle").size.width/2), y: actualY + 60 ), duration: TimeInterval(actualDuration/8))
        let actionMove2 = SKAction.move(to: CGPoint(x: scene!.size.width*(7/8), y: actualY - 60), duration: TimeInterval(actualDuration/8))
        let actionMove3 = SKAction.move(to: CGPoint(x: scene!.size.width*(6/8), y: actualY + 60), duration: TimeInterval(actualDuration/8))
        let actionMove4 = SKAction.move(to: CGPoint(x: scene!.size.width*(5/8), y: actualY - 60), duration: TimeInterval(actualDuration/8))
        let actionMove5 = SKAction.move(to: CGPoint(x: scene!.size.width*(4/8), y: actualY + 60), duration: TimeInterval(actualDuration/8))
        let actionMove6 = SKAction.move(to: CGPoint(x: scene!.size.width*(3/8), y: actualY - 60), duration: TimeInterval(actualDuration/8))
        let actionMove7 = SKAction.move(to: CGPoint(x: scene!.size.width*(2/8), y: actualY + 60), duration: TimeInterval(actualDuration/8))
        let actionMove8 = SKAction.move(to: CGPoint(x: scene!.size.width*(1/8), y: actualY - 60), duration: TimeInterval(actualDuration/8))
        let actionMoveDone = SKAction.removeFromParent()
        
        node.run(SKAction.sequence([actionMove2, actionMove3, actionMove4, actionMove5, actionMove6, actionMove7, actionMove8, actionMove1, actionMoveDone]))
    }
    
    //BeeHypno sprite creation and actions
    func beeMovingTowardsYou()
    {
        let actualY: CGFloat = random(min: 750, max: 600)
        let actualDuration:CGFloat = 5.0// = CGFloat(5.0)
        
        let nodePos = CGPoint(x: size.width + #imageLiteral(resourceName: "BeeHypno").size.width, y: actualY)
        let node = ObjectCollider(imageNamed: "BeeHypno", name: "BeeHypnoObject", position: nodePos, color: UIColor.black, blendFactor: 0.0, categoryMask: PhysicsCategory.Monster, contactMask: PhysicsCategory.Projectile, zPosition: visualPosition.Enemy)
        addChild(node)
        
        let actionMove = SKAction.move(to: CGPoint(x: -(#imageLiteral(resourceName: "BeeHypno").size.width/2), y: random(min: 280, max: 550)), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        node.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //Mark: - Functions related to collision -
    
    //Projecile colliding with Monster actions
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode)
    {
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    //Player collider with Monster actions
    func playerDidCollideWithEnemies(enemy: SKSpriteNode, player: SKSpriteNode)
    {
        guard let isLife = life.popLast()
        else
        {
            updateAndChangeToGameOver()
            return
        }
        isLife.removeFromParent()
        enemy.removeFromParent()
    }
    
    //Object collider with each other actions
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0))
        {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode
            {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0))
        {
            if let enemy = firstBody.node as? SKSpriteNode, let
                player = secondBody.node as? SKSpriteNode
            {
                playerDidCollideWithEnemies(enemy: enemy, player: player)
            }
        }
        
    }
    
    //Mark: - Touch Detection -
    
    //To check whether the player wants to exit the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self);
            
            if atPoint(location).name == "Exit"
            {
                updateAndChangeToGameOver()
            }
        }
    }
    
    //Gameplay touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        ////MARK: - Choose one of the touches to work -
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        //This side of the screen is for the player to jump
        if (touchLocation.x < size.width/2)
        {
            if (!playerUp)
            {
                // Music by jeremysykes, taken from freesound.org
                //MARK: - Arrow shoot Music -
                run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
                playerUp = true
                
                //Up action
                let jumpUpAction1 = SKAction.moveBy(x: 0, y: 160, duration: 0.15)
                let jumpUpAction2 = SKAction.moveBy(x: 0, y: 110, duration: 0.15)
                let jumpUpAction3 = SKAction.moveBy(x: 0, y: 60, duration: 0.15)
                
                //Air time
                let jumpWaitAction1 = SKAction.moveBy(x: 0, y: 5, duration: 0.05)
                let jumpWaitAction2 = SKAction.moveBy(x: 0, y: -5, duration: 0.05)
                
                //Down action
                let jumpDownAction1 = SKAction.moveBy(x: 0, y: -160, duration: 0.15)
                let jumpDownAction2 = SKAction.moveBy(x: 0, y: -110, duration: 0.15)
                let jumpDownAction3 = SKAction.moveBy(x: 0, y: -60, duration: 0.15)
                // sequence of move yup then down
                
                let jumpSequence = SKAction.sequence([jumpUpAction1,jumpUpAction2,jumpUpAction3, jumpWaitAction1, jumpWaitAction2, jumpDownAction3, jumpDownAction2, jumpDownAction1])
                
                //MARK: - Player run sequence -
                player.run(jumpSequence, completion: {self.playerUp = false})
            }
        }
        //This side of the screen is for shooting the arrow
        else if (!projectilePresent)
        {
            // Music by MusicLegends, taken from freesound.org
            //MARK: - Jump Music -
            run(SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false))
            
            let nodePos = player.position
            
            let node = ObjectCollider(imageNamed: "projectile", name: "ProjectileObject", position: nodePos, color: UIColor.black, blendFactor: 0.0, categoryMask: PhysicsCategory.Projectile, contactMask: PhysicsCategory.Monster, zPosition: visualPosition.Arrow)
            
            projectilePresent = true
            
            addChild(node)
            
            let actionMove = SKAction.move(to: CGPoint(x: scene!.size.width + 50, y: nodePos.y), duration: 1.0)
            let actionMoveDone = SKAction.removeFromParent()
            
            //Do both actions in parallel
            //Player Shooting Animation
            player.run( SKAction.sequence([SKAction.animate(with: playerShootingFrames, timePerFrame: 0.1)]),withKey: "shootingInPlacePlayer")
            
            //Arrow shot
            node.run(SKAction.sequence([actionMove, actionMoveDone]))
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.projectilePresent = false
            }
        }
    }
    
    //Mark: - The update loop for moving ground and generating enemies -
    override func update(_ currentTime: TimeInterval)
    {
        if generateEnemies == true
        {
            generateEnemies = false
            makeEnemies()
        }
        moveGrounds()
    }
    
    
    //Mark: - Gameover -
    func updateAndChangeToGameOver(){
        timer.invalidate()
        if (Score.sharedData.allTimeBest < Score.levelTime)
        {
            Score.sharedData.allTimeBest = Score.levelTime
        }
        let scene = GameOverScene(fileNamed: "GameEndScene")
        scene?.scaleMode = .aspectFill
        view!.presentScene(scene!, transition: SKTransition.doorsOpenVertical(withDuration: 2))
    }
    
}
