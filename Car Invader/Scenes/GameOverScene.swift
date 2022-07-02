//
//  GameOverScene.swift
//  Beach Race
//
//  Created by muhamed jaber on 24.09.20.
//

import Foundation
import SpriteKit



class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView)  {
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.setScale(3)
        background.position = CGPoint(x:self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
       
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
     
        let menuLabel = SKLabelNode(fontNamed: "The Bold Font")
        menuLabel.text = "Menu"
        menuLabel.fontSize = 150
        menuLabel.fontColor = SKColor.black
        menuLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.125)
        menuLabel.zPosition = 1
        menuLabel.name = "menuLabel"
        self.addChild(menuLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        
        
        
       
        restartLabel.text = "Restart"
        restartLabel.fontSize = 150
        restartLabel.fontColor = SKColor.black
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SoundPlayer.shared.buttonSound)
            for touch: AnyObject in touches{
                
                let pointOfTouch = touch.location(in: self)
               
                if restartLabel.contains(pointOfTouch){
                    
                    let sceneToMoveTo = GameScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTansition = SKTransition.fade(withDuration: 1.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTansition)
                    
                    
                    
                }
                
                _ = SKAction.playSoundFileNamed("button", waitForCompletion: false)
                _ = touch.location(in: self)
                let nodeITapped = atPoint(pointOfTouch)
                
                if nodeITapped.name == "menuLabel" {
                    
                    let sceneToMoveTo = MainMenuScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
                
                
            }
      
        
        
    }
    
    
    
    
    
    
    
}
