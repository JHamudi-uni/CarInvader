//
//  GameViewController.swift
//  Beach Race
//
//  Created by muhamed jaber on 23.09.20.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation



var soundOn = true


class GameViewController: UIViewController {
    
    static var backingAudio = AVAudioPlayer()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        playSound()
     
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        
         let skView = self.view as! SKView
            // Load the SKScene from 'GameScene.sks'
         
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(scene)
            
            skView.ignoresSiblingOrder = true
            skView.showsFPS = false
            skView.showsNodeCount = false
            
    }
        


        
    func playSound(){
        
      
        if soundOn == false {
            
            GameViewController.backingAudio.pause()
            soundOn = true
            print(soundOn)
      
                
        }else {
            let filePath = Bundle.main.path(forResource: "ride to the city",ofType: "mp3")
            let audioNSURL = NSURL(fileURLWithPath: filePath!)
            
            do {
                GameViewController.backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL)
            }
            catch {
                return print("Cant find the Audio")
            }
            
            GameViewController.backingAudio.numberOfLoops = -1
            GameViewController.backingAudio.volume = 1
            GameViewController.backingAudio.play()
            
        }
  
    }
   

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
