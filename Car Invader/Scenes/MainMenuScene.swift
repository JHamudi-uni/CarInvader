//
//  MainMenuScene.swift
//  Beach Race
//
//  Created by muhamed jaber on 24.09.20.
//

import Foundation
import SpriteKit

var counter = 0
var soundButton = "sound1"
let mainMenu = MainMenuScene()

class MainMenuScene: SKScene{
    
   // var sceneManagerDelegate: SceneManagerDelegate?
   
 
    
    override func didMove(to view: SKView) {
        
        
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.setScale(3)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let cash = SKLabelNode(fontNamed: "The Bold Font")
        cash.text = "Cash: \(coins)"
        cash.fontSize = 75
        cash.fontColor = SKColor.black
        if coins < 99 {
            cash.position = CGPoint(x: self.size.width*0.15, y:self.size.height*0.95)
        } else if coins > 99 && coins < 1000 {
            cash.position = CGPoint(x: self.size.width*0.15 + cash.frame.size.width/8, y:self.size.height*0.95)
        } else if coins > 999 && coins < 10000 {
            cash.position = CGPoint(x: self.size.width*0.15 + cash.frame.size.width/6, y:self.size.height*0.95)
        } else {
            cash.position = CGPoint(x: self.size.width*0.15 + cash.frame.size.width/4, y:self.size.height*0.95)

        }
        cash.zPosition = 1
        self.addChild(cash)
        
        
        let sound1 = SKSpriteNode(imageNamed: soundButton)
        sound1.position = CGPoint(x:self.size.width*0.85, y: self.size.height*0.95)
        sound1.zPosition = 1
        sound1.name = "sound1"
        self.addChild(sound1)
        
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Car"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.black
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.text = "Invader"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.black
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.615)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        
        let startGame = SKLabelNode(fontNamed: "The Bold Font")
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = SKColor.black
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        let shop = SKLabelNode(fontNamed: "The Bold Font")  //SKSpriteNode -> Button
        shop.text = "Shop"
        shop.fontSize = 150
        shop.fontColor = SKColor.black
        shop.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.225)
        shop.zPosition = 1
        shop.name = "shopButton"
        self.addChild(shop)
        
       
        
    }
    
    func reloadScene(){
        mainMenu.didMove(to: (self.scene?.view)!)
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.1)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            _ = SKAction.playSoundFileNamed("button", waitForCompletion: false)
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            let audioChange = GameViewController()
           
            
            //if SoundPlayer.shared.soundsOn {}
                run(SoundPlayer.shared.buttonSound)
            
            if nodeITapped.name == "startButton" {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if nodeITapped.name == "shopButton" {
                
                let sceneToMoveTo = ShopScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
          
            if nodeITapped.name == "sound1" {
                
                
                if counter%2 == 0 {
                    soundOn = false
                    soundButton = "sound0"
                    reloadScene()
                    
                }
                
                else {
                    soundButton = "sound1"
                    reloadScene()

                }
                    
                counter += 1
                audioChange.playSound()
               
      
            }
              
        }
        
    }
    
    
//    func layoutView(){
//
//        let settingsButton = SpriteKitButton(defaultButtonImage: "tree", action: handleDelegates, index: 0)
//        settingsButton.scale(to: frame.size, width: false, multiplier: 0.075)
//        settingsButton.position = CGPoint(x: frame.midX - settingsButton.frame.width * 2, y: settingsButton.position.y - settingsButton.size.height * 2)
//        settingsButton.zPosition = 2
//        addChild(settingsButton)
//
//    }
//
//    func handleDelegates(index: Int) {
//        switch index {
//
//        case 0:
//            presentSettingsScene()
//
//        default:
//            break
//        }
//    }
    
}


