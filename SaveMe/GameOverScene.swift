//
//  GameOverScene.swift
//  SaveMe
//
//  Created by Ashok on 10/25/16.
//  Copyright © 2016 Ashok. All rights reserved.
//
import Foundation
import SpriteKit
import CoreData

class GameOverScene: SKScene {
    
    var gameOver = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var youScoreLabel = SKLabelNode()
    var score = 0
    var pauseText = SKLabelNode(fontNamed: "chalkboardSE-Bold")
    
    
    override func didMove(to view: SKView) {
        
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nohideAd"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAndShow"), object: nil)

        
        let defaults = UserDefaults.standard
        let resultScore: Int = UserDefaults.standard.integer(forKey: "userScore")
        
        backgroundColor = SKColor.white
        
        gameOver = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        gameOver.fontSize = 60
        gameOver.fontColor = SKColor.black
        gameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY+100)
        gameOver.text = "GameOver"
        self.addChild(gameOver)
        
        youScoreLabel = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        youScoreLabel.fontSize = 30
        youScoreLabel.fontColor = SKColor.black
        youScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+50)
        youScoreLabel.text = NSString(format: "CurrentScore: %i",  resultScore) as String
        
        highScoreLabel = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY-10)
        // highscoreLabel.text = "0"
        
        pauseText.text = "Play Again"
        pauseText.fontSize = 50
        pauseText.position = CGPoint(x: self.frame.midX, y: self.frame.midY-70)
        // pauseText.zPosition = 3
        pauseText.fontColor = SKColor.black
        self.addChild(pauseText)
        
        if (defaults.value(forKey: "highscore") != nil) {
            score = defaults.value(forKey: "highscore") as! NSInteger!
            highScoreLabel.text = NSString(format: "HighScore: %i",  score) as String
        }
        
        if(resultScore > score)
        {
            score = resultScore
            highScoreLabel.text = NSString(format: "New HighScore: %i",  score) as String
            let defaults = UserDefaults.standard
            defaults.setValue(score, forKey: "highscore")
            defaults.synchronize()
            
            self.addChild(highScoreLabel)
        }
        else{
            self.addChild(youScoreLabel)
            self.addChild(highScoreLabel)
        }
        
    }
    
    func displayAd() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAndShow"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.pauseText {
                let scene = GameScene(size: self.size)
                let skView = self.view as SKView!
                //skView?.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = (skView?.bounds.size)!
                skView?.presentScene(scene)
                
            }
        }
    }
    
    
    /*
     init(size: CGSize, won:Bool) {
     
     super.init(size: size)
     
     // 1
     backgroundColor = SKColor.white
     
     // 2
     let message = won ? "You Won!" : "You Lose :["
     
     // 3
     let label = SKLabelNode(fontNamed: "Chalkduster")
     label.text = message
     label.fontSize = 40
     label.fontColor = SKColor.black
     label.position = CGPoint(x: size.width/2, y: size.height/2)
     addChild(label)
     
     // 4
     run(SKAction.sequence([
     SKAction.wait(forDuration: 3.0),
     SKAction.run() {
     // 5
     let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
     let scene = GameScene(size: size)
     self.view?.presentScene(scene, transition:reveal)
     }
     ]))
     
     }
     
     // 6
     required init(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }*/
}
