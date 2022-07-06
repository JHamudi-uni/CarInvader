//
//  GameScene.swift
//  Beach Race
//
//  Created by muhamed jaber on 23.09.20.
//

import SpriteKit
import GameplayKit


var gameScore = 0
var coins = 30000



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let worldNode = SKNode()
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    var pauseButtonPic = "pauseButton"
    let resumeButtonPic = "resumeButton"
    let player = SKSpriteNode(imageNamed: "BlueCar")
    let bulletSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let schnellfeuerSound = SKAction.playSoundFileNamed("schnellfeuer.wav", waitForCompletion: false)
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")

    var livesNumber = 30
    var levelNumber = 0
    var car = SKSpriteNode()
    var currentGameState = gameState.preGame
    var gameArea: CGRect
    var timer = Timer()

    
    enum gameState{
        case preGame //before start of the game
        case inGame // im Spiel
        case pausedGame
        case afterGamer
    }
    
    //MARK: - PhysicsCategories
    

    
    struct  PhysicsCategories {
        static let None: UInt32 = 0   // 0
        static let Player: UInt32 = 0b1  // 1
        static let Bullet: UInt32 = 0b10 // 2
        static let Enemy: UInt32 = 0b100 // 4
        static let Powerup: UInt32 = 0b1000 // 8
    }
    
    
    //MARK: - Random

    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        
        return random() * (max-min) + min  // returned das obere random
    }
   
    
    //MARK: - init

    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        super.init(size: size)
        
        
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
  /*
    @objc func pauseGame(){
        currentGameState = gameState.pausedGame
        self.view?.isPaused = true
        SKAction.wait(forDuration: 2.0)

    }
    
    func keepGoing(){
        self.view?.isPaused = false
    }
   
   */
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton" )
    let pauseButton2 = SKSpriteNode(imageNamed: "resumeButton" )
    func startGame(){
        
        
        pauseButton.position = CGPoint(x:self.size.width/2.005, y: self.size.height*0.90)
        pauseButton.zPosition = 170
        pauseButton.size.width = pauseButton.size.width*1.7
        pauseButton.size.height = pauseButton.size.width*1.05
        pauseButton.name = "pauseButton"
        worldNode.addChild(pauseButton)
        
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(GameScene.changeButtonImage), userInfo: nil, repeats: true)
        changeBulletSpeed()
        currentGameState = gameState.inGame
        //bulletSpeed0()

        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startPowerupAction = SKAction.run(spawnPowerupRate)
       // let updateButton = SKAction.run(changePauseButtonImage)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction, startPowerupAction])
        player.run(startGameSequence)
        
        
    }
    
    func spawnPowerupRate(){
        let spawnPup = SKAction.run(spawnPowerup)
        let waitToSpawnPowerup = SKAction.wait(forDuration: 5)
        let spawnPowerup = SKAction.sequence([waitToSpawnPowerup, spawnPup])
        let spawnForeverPowerup = SKAction.repeatForever(spawnPowerup)
        worldNode.run(spawnForeverPowerup)
        
        
    }
   
    func loseALive(){
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 1 {
            livesLabel.fontColor = UIColor.red
        }
        if livesNumber == 0 {
            runGameOver()
            //self.view?.isPaused = true
            coins += gameScore
        }
        
    }
    var boolean = true
    
    func changeBulletSpeed(){
        if(boolean == true){
            timer.invalidate()
            bulletSpeed0()
            
        }else {
            timer.invalidate()
            bulletSpeed1()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.timer.invalidate()
            }
            boolean = true
            
        }
        
   
    }
    
    //let worldNode = SKNode()

 
   
    
    
    
    override func didMove(to view: SKView) {
       
        addChild(worldNode)
        
        gameScore = 0
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.physicsWorld.contactDelegate = self
 
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        scoreLabel.position = CGPoint(x: self.size.width*0.10, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)

        
        
        

        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        livesLabel.position = CGPoint(x: self.size.width*0.90, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
    
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0  // unsichtbar
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        for i in 0...1 {
            
        let background = SKSpriteNode(imageNamed: "street")
        background.size = self.size
        background.anchorPoint = CGPoint(x:0.5, y:0)
        background.position = CGPoint(x: self.size.width/2,
                                      y: self.size.height*CGFloat(i))
        background.zPosition = 0
        background.name = "Background"
        worldNode.addChild(background)
        //self.addChild(background)

            
        }
      //setUp()
        
        
        player.setScale(0.8)
        player.position = CGPoint(x: self.size.width/2, y:0 - self.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        //self.addChild(player)
        worldNode.addChild(player)
                    
        
        
        

//      createRoadStrip()
//        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: false)
        }
  
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0          // wie schnell background sich bewegt
    
    override func update(_ currentTime: TimeInterval) {  //Ruft showroadstrip jeden frame/s: 60 frames => 60 mal pro sekunde
        //showRoadStrip()
        
        if lastUpdateTime == 0 {
            
            lastUpdateTime = currentTime
        }
        else{
            
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
         
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        worldNode.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
                
            }
            
            if background.position.y < -self.size.height{
                
                background.position.y += self.size.height*2
            }
            
            
        }
  
    }
/*
    func setUp(){
        
        car = worldNode.childNode(withName: "car") as! SKSpriteNode
    }
   */
/*
    @objc func createRoadStrip(){
        
        let roadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        roadStrip.strokeColor = SKColor.white
        roadStrip.fillColor = SKColor.white
        roadStrip.alpha = 0.4
        roadStrip.name = "roadStrip"
        roadStrip.zPosition = 10
        roadStrip.position.x = 0
        roadStrip.position.y = 700
        //addChild(roadStrip)
        worldNode.addChild(roadStrip)

    
        
        
    }
    */
   
  /*
    func showRoadStrip(){
        
        enumerateChildNodes(withName: "roadStrip", using: {(roadStrip, stop) in
            
            let strip = roadStrip as! SKShapeNode
            strip.position.y -=  30
        })
        
    }
    */
    //MARK: - GameOver
   
    func runGameOver(){
        
        currentGameState = gameState.afterGamer
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }

    func stopTimer(){
        timer.invalidate()
    }
    
   // MARK: - didBegin Contact
    
    //Läuft wenn es Konakt zwischen Physiksbodys gibt.
    
    func didBegin(_ contact: SKPhysicsContact) {


        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
            
            
        } else{
            body1 = contact.bodyB // body1 ist immer der body mit der kleineren bitmask nummer
            body2 = contact.bodyA
            
        }
        
        if  body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Powerup{
            
            
            spawnSchnellfeuerEffekt(spawnPosition: body1.node!.position)  // ersetzen durch coole effekte wenn man powerups einsammelt
            
            // Funktion für schnellfeuer für kurze zeit hier ersetzen !
            
          
            //timer.invalidate()
            
            timer.invalidate()
            boolean = false
            changeBulletSpeed()
        
            //self.bulletSpeed1()
            if currentGameState == gameState.inGame {
            //boolean = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let stopTimer = SKAction.run(self.stopTimer)
    
                self.run(stopTimer)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.changeBulletSpeed()

                    
                }
                //self.boolean = true
                //self.changeBulletSpeed()
                
            }
            }
         
            
            
            //self.timer.invalidate()
            
            //let changeBulletSpeedAction = SKAction.run(bulletSpeed1)
            //let returnNormalBulletSpeedAction = SKAction.run(bulletSpeed0)
            
//            let waitToEndPowerup = SKAction.wait(forDuration: 5)
//            let returnBulletSpeedAction = SKAction.run(bulletSpeed0)
          //  let changeBulletSpeed = SKAction.sequence([changeBulletSpeedAction])
            
            
        
            //self.run(changeBulletSpeed)
            //worldNode.run(changeBulletSpeed)
            body2.node?.removeFromParent()
            //SKAction.wait(forDuration: 1)
           /*
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                //self.timer.invalidate()
                //num = true
                // HIER
                self.bulletSpeed0()
                self.timer.invalidate()
                
             }
          
            timer.invalidate()
            
            //num = true
            */
           
           
        }
     
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
                
            }
            
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()

            runGameOver()
            coins += gameScore
        }
        
        if body2.node != nil {
            if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {

                
                addScore()
                
                if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
                }
                
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
            }
        }
        else {
            
            if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {

                
               
                
                if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
                }
                
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
            }
            
        }
        
    }
    
    // MARK: - spawnExplosion
    
    
    
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(3)
        worldNode.addChild(explosion)
        //self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
        //worldNode.run(explosionSequence)
    }
    
    
    
    func spawnSchnellfeuerEffekt(spawnPosition: CGPoint){
        let schnellfeuerEffekt = SKSpriteNode(imageNamed: "schnellfeuerEffekt")
        schnellfeuerEffekt.position = spawnPosition
        schnellfeuerEffekt.zPosition = 3
        schnellfeuerEffekt.setScale(3)
        //self.addChild(schnellfeuerEffekt)
        worldNode.addChild(schnellfeuerEffekt)

        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let schnellfeuerSequence = SKAction.sequence([schnellfeuerSound, scaleIn, fadeOut, delete])
        
        schnellfeuerEffekt.run(schnellfeuerSequence)
        
        
    }
    
    
    // Läuft wenn wir unseren finger bewegen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            //changeButtonImage()
            let pointOfTouch = touch.location(in: worldNode)
            let previousPointOfTouch = touch.previousLocation(in: worldNode)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            //let amountDragged2 = pointOfTouch.y - previousPointOfTouch.y
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
                
            }
            
            if player.position.x > gameArea.maxX {
                player.position.x = gameArea.maxX
            }
            
            if(player.position.x < gameArea.minX){
                player.position.x = gameArea.minX
            }
            
            //player.position.y += amountDragged2

        }
    }
    
    @objc func fireBullet(){
      
  
        let bullet = SKSpriteNode(imageNamed: "bullet\(nummer)")
        bullet.name = "Bullet"
        bullet.setScale(0.4)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        let action = SKAction.moveTo(y: self.size.height + 30, duration: 1.0)
        bullet.run(SKAction.repeatForever(action))
        
        //self.addChild(bullet)
        worldNode.addChild(bullet)
       
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBullet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
            bullet.run(bulletSequence)
        
        
    }

  
    @objc func bulletSpeed0(){
        
        if currentGameState != gameState.afterGamer {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
                self.fireBullet()
            })
        }
    }
    
    func bulletSpeed1(){
        
        if currentGameState != gameState.afterGamer {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { _ in
                self.fireBullet()
            })
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.timer.invalidate()
//
//         }

        
        
        
    }
   /*
    func noBulletSpeed(){
        
        _ = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(GameScene.fireBullet), userInfo: nil, repeats: false)
           
    }
    */

//    func updateCounting(){
//        NSLog("counting..")
//    }
    
    
    // MARK: - touchesBegan
    
    
    var bool = true
    var n = 1
    

   
//    func changePauseButtonImage(){
//
//        if (n == 1) {
//            pauseButtonPic.removeAll()
//            pauseButtonPic = "pauseButton"
////            pauseButton.zPosition = 0
////            pauseButton.removeFromParent()
//        }else {
//            pauseButtonPic = "resumeButton"
//        }
//    }
//
    @objc func changeButtonImage(){
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
   
    
        if currentGameState == gameState.pausedGame{
            //pauseButton.run(scaleSequence)
            pauseButton.run(scaleSequence)
            if let child = worldNode.childNode(withName: "pauseButton") as? SKSpriteNode {
                child.removeFromParent()
            }
            
        }else {
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        for touch: AnyObject in touches{
        let pointOfTouch = touch.location(in: self)
        let nodeITapped = atPoint(pointOfTouch)
            
            
//            let pauseButton = SKSpriteNode(imageNamed: pauseButtonPic )
//            pauseButton.position = CGPoint(x:self.size.width/2.005, y: self.size.height*0.90)
//            pauseButton.zPosition = 170
//            pauseButton.size.width = pauseButton.size.width*1.7
//            pauseButton.size.height = pauseButton.size.width*1.05
//            pauseButton.name = "pauseButton"
//            worldNode.addChild(pauseButton)
//
            
            
            pauseButton2.position = CGPoint(x:self.size.width/2.005, y: self.size.height*0.90)
            pauseButton2.zPosition = 171
            pauseButton2.size.width = pauseButton.size.width*1.0
            pauseButton2.size.height = pauseButton.size.width*1.05
            pauseButton2.name = "pauseButton2"
           
        
        

        if nodeITapped.name == "pauseButton"{
            currentGameState = gameState.pausedGame
//            pauseButtonPic = "resumeButton"
            print(n)
            //changeButtonImage()
//            if let child = worldNode.childNode(withName: "pauseButton") as? SKSpriteNode {
//                child.removeFromParent()
//            }
          
            //pauseButton.removeFromParent()
            //pauseButton.removeFromParent()
           
            //changePauseButtonImage()
            
            
            worldNode.addChild(pauseButton2)
            //pauseButton.zPosition = 0
            n = 0
        
            run(SoundPlayer.shared.buttonSound)
            
            //pauseButton.isHidden = true
            //pauseButton.run(SKAction.fadeOut(withDuration: 0.5))
            //pauseButtonPic = "tree"
            timer.invalidate()
            worldNode.isPaused = true
            physicsWorld.speed = 0
           
            
            //self.isUserInteractionEnabled = true
            //noBulletSpeed()
            //bulletSpeed1()
            //Timer.invalidate()

         
        }else if nodeITapped.name == "pauseButton2"{
            currentGameState = gameState.inGame
            print(n)
            if let child = worldNode.childNode(withName: "pauseButton2") as? SKSpriteNode {
                child.removeFromParent()
            }
          
           
            
            //changePauseButtonImage()
            n = 1
            timer.invalidate()
            
         

              
            run(SoundPlayer.shared.buttonSound)
            changeBulletSpeed()
            //bulletSpeed0()
            worldNode.addChild(pauseButton)

               
                //pauseButtonPic = "tree"

                
            worldNode.isPaused = false
            physicsWorld.speed = 1.0
             
        }
            
            
        if currentGameState == gameState.preGame{
            startGame()
        }else if currentGameState == gameState.inGame {
            
            let bulletImageName = "bullet\(nummer)"
            
            
            if(bool && bulletImageName == "bullet0"){
                /*
                _ = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(GameScene.bulletSpeed0), userInfo: nil, repeats: true)
                 */
                //bulletSpeed0()
                bool = false
                
            }else if (bool && bulletImageName == "bullet1"){
                
                //bulletSpeed0()
                bool = false
            }else if (bool && bulletImageName == "bullet2"){
                
                //bulletSpeed0()
                bool = false
            }
            
            
        }else if currentGameState == gameState.pausedGame {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let deleteAction = SKAction.removeFromParent()
            let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
            //pauseButton.run(deleteSequence)
        }
        }}
        
       
    
    func spawnPowerup(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let schnellfeuer = SKSpriteNode(imageNamed: "schnellfeuer")
        schnellfeuer.name = "Powerup"
        schnellfeuer.setScale(0.8)
        schnellfeuer.position = startPoint
        schnellfeuer.zPosition = 2
        schnellfeuer.physicsBody = SKPhysicsBody(rectangleOf: schnellfeuer.size)
        schnellfeuer.physicsBody!.affectedByGravity = false
        schnellfeuer.physicsBody!.categoryBitMask = PhysicsCategories.Powerup
        schnellfeuer.physicsBody!.collisionBitMask = PhysicsCategories.None
        schnellfeuer.physicsBody!.contactTestBitMask = PhysicsCategories.Player

        //self.addChild(schnellfeuer)
        worldNode.addChild(schnellfeuer)
        //let loseALifeAction = SKAction.run(loseALive)
    
        //let gameOverAction = SKAction.run(gameOver)
        let movePowerup = SKAction.move(to: endPoint, duration: 3.0)
        let deletePowerup = SKAction.removeFromParent()
        let PowerupSequnce = SKAction.sequence([movePowerup, deletePowerup])
        
        if currentGameState == gameState.inGame{
            schnellfeuer.run(PowerupSequnce)
            //worldNode.run(PowerupSequnce)
            //schnellfeuer.run(enemySequnce)
        }
            
        
        
    }
    
    //MARK: - SpawnEnemy
    
    

    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "BlackCar")
        enemy.name = "Enemy"
        enemy.setScale(0.8)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet

        //self.addChild(enemy)
        worldNode.addChild(enemy)
       
       
        let loseALifeAction = SKAction.run(loseALive)
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequnce = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequnce)
        
            //worldNode.run(enemySequnce)
        }
       
      /*
        // Damit der Gegner richtig rotiert beim runter fahren
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
       */
   
    }
    
    // MARK: - StartNewLevel
    
    
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        // Damit kann man varrieren wie schwierig das level werden soll, in dem man
        // die Enemys schneller spawnen lässt.
        
        switch levelNumber {
        case 1:
            levelDuration = 2.0
        case 2: levelDuration = 1.5
        case 3: levelDuration = 1.0
        case 4: levelDuration = 0.5
        
            
        default:
            levelDuration = 0.6
            print("cant find level info")
        }
        
        //let pauseButton = SKAction.run(changePauseButtonImage)
        //let updatePauseButton = SKAction.repeatForever(pauseButton)
        //worldNode.run(updatePauseButton)
        
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration) // Zeit für enemy spawn
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
//        let spawnPup = SKAction.run(spawnPowerup)
//        let waitToSpawnPowerup = SKAction.wait(forDuration: 5)
//        let spawnPowerup = SKAction.sequence([waitToSpawnPowerup, spawnPup])
//        let spawnForeverPowerup = SKAction.repeatForever(spawnPowerup)
//        worldNode.run(spawnForeverPowerup)
//
//
          worldNode.run(spawnForever, withKey: "spawningEnemies")
    }
    
    
      func addScore(){
          
        if gameScore < 25 {
          gameScore += 1
        } else if gameScore >= 25 && gameScore < 75  {
          gameScore += 2  // nach 25 autos
        } else if gameScore >= 75 && gameScore < 275  {
            gameScore += 4  // nach 50 autos
        } else {
            gameScore += 8  // nach 100 autos

        }
        
          scoreLabel.text = "Score: \(gameScore)"
          
          if gameScore == 25 || gameScore == 75 || gameScore == 275 {
              startNewLevel()
              
          }
      }

    }
