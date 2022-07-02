//
//  ShopScene.swift
//  Car Invader
//
//  Created by muhamed jaber on 29.09.20.
//

import Foundation
import SpriteKit



var nummer = 0
var bulletPic = "bulletRahmen0"
var bulletPic2 = "bullet1"
var bulletPic3 = "bullet2"


class ShopScene: SKScene{
    
    
    func addLabel(){
        let newView = UILabel()

        self.view!.addSubview(newView)

            newView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
    
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "shopBackground")
        background.setScale(3)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let menuLabel = SKLabelNode(fontNamed: "The Bold Font")
        menuLabel.text = "Menu"
        menuLabel.fontSize = 150
        menuLabel.fontColor = SKColor.black
        menuLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.125)
        menuLabel.zPosition = 1
        menuLabel.name = "menuLabel"
        self.addChild(menuLabel)
        
        
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
        
        let bullet0 = SKSpriteNode(imageNamed: bulletPic)
        bullet0.position = CGPoint(x:self.size.width/2, y: self.size.height*0.875)
        bullet0.zPosition = 1
        bullet0.name = "bullet0"
        self.addChild(bullet0)
        
        
        let bullet1 = SKSpriteNode(imageNamed: bulletPic2)
        bullet1.position = CGPoint(x:self.size.width/2, y: self.size.height*0.675)
        bullet1.zPosition = 1
        bullet1.name = "bullet1"
        self.addChild(bullet1)
        
        let bullet2 = SKSpriteNode(imageNamed: bulletPic3)
        bullet2.position = CGPoint(x:self.size.width/2, y: self.size.height*0.475)
        bullet2.zPosition = 1
        bullet2.name = "bullet2"
        self.addChild(bullet2)
        
        let price1 = SKLabelNode(fontNamed: "The Bold Font")        // ALS IMAGE DAMIT ES ANKLICKBAR WIRD
        price1.text = "200"
        price1.fontSize = 75
        price1.fontColor = SKColor.black
        price1.position = CGPoint(x:self.size.width/1.5, y: self.size.height*0.675)
        price1.zPosition = 1
        self.addChild(price1)
        
        let price2 = SKLabelNode(fontNamed: "The Bold Font")        // ALS IMAGE DAMIT ES ANKLICKBAR WIRD
        price2.text = "500"
        price2.fontSize = 75
        price2.fontColor = SKColor.black
        price2.position = CGPoint(x:self.size.width/1.5, y: self.size.height*0.475)
        price2.zPosition = 1
        self.addChild(price2)
        
        //let upgrade0 = SKSpriteNode(imageNamed: "upgrade0")
        
        
        
        
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            _ = SKAction.playSoundFileNamed("button", waitForCompletion: false)
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            
            
            //if SoundPlayer.shared.soundsOn {}
                run(SoundPlayer.shared.buttonSound)
            
            
//            switch nodeITapped.name{
//
//            case "bullet0": nummer = 0
//            case "bullet1": nummer = 1
//            default: nummer = 0
//                print("bullet fehler")
//            }
            
        
            
            if nodeITapped.name == "bullet0"{
                nummer = 0
                if bulletPic != "bulletRahmen0" {
                
                
                bulletPic = "bulletRahmen0"
                bulletPic2 = "bullet1"
                bulletPic3 = "bullet2"

                
                }
            
                
                let sceneToMoveTo = ShopScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
//                let bullet0 = SKSpriteNode()
//
//                let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
//                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
//                let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
//                bullet0.run(scaleSequence)
                
                
                
                
            }else if nodeITapped.name == "bullet1" && coins >= 200
            {
                coins -= 200
                nummer = 1
                
                
                bulletPic = "bullet0"
                bulletPic2 = "bulletRahmen1"
                bulletPic3 = "bullet2"
                let sceneToMoveTo = ShopScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
               
            }
            else if nodeITapped.name == "bullet2" && coins >= 500
            {
                coins -= 500
                nummer = 2
                
                bulletPic = "bullet0"
                bulletPic2 = "bullet1"
                bulletPic3 = "bulletRahmen2"
                let sceneToMoveTo = ShopScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
            
            
            if nodeITapped.name == "menuLabel" {
                
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    
}
    
    

        
        
        
        
        
    }
    
    
    
    
    
    
    
    

