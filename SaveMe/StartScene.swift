//
//  StartScene.swift
//  SaveMe
//
//  Created by Ashok on 10/25/16.
//  Copyright © 2016 Ashok. All rights reserved.
//
import UIKit
import SpriteKit


class StartScene: SKScene {
    var gamename = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    let playButton = SKSpriteNode(imageNamed:"play")
    var suggestion = SKLabelNode()
    
    var Score1 = 0
    let Pi = CGFloat(M_PI)

    override func didMove(to view: SKView) {

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideAd"), object: nil)
        self.backgroundColor = UIColor.white
        
        
        let defaults = UserDefaults.standard
        let resultScore: Int = UserDefaults.standard.integer(forKey: "userScore")
        
        gamename = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        gamename.fontSize = 50
        gamename.fontColor = SKColor.black
        gamename.position = CGPoint(x: self.frame.midX, y: self.frame.midY+150)
        gamename.text = "SaveMee"
        self.addChild(gamename)
        
        let player = SKSpriteNode(imageNamed: "hero01")

        let h1 = SKTexture.init(imageNamed: "hero01")
        let h2 = SKTexture.init(imageNamed: "hero02")
        
        let frames: [SKTexture] = [h1, h2 ]
        let animation = SKAction.animate(with: frames, timePerFrame: 0.50)
        player.run(SKAction.repeatForever(animation))
        player.position = CGPoint(x: self.frame.midX+135, y: self.frame.midY+160)
        player.size = CGSize(width: 50.0, height: 50.0)
        player.zPosition = 2
        addChild(player)
        
        
        
        highscoreLabel = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        highscoreLabel.fontSize = 30
        highscoreLabel.fontColor = SKColor.black
        highscoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+100)
        // highscoreLabel.text = "0"
        self.addChild(highscoreLabel)
        
        if (defaults.value(forKey: "highscore") != nil) {
            Score1 = defaults.value(forKey: "highscore") as! NSInteger!
            highscoreLabel.text = NSString(format: "HighScore: %i",  Score1) as String
        }
        
        if(resultScore > Score1)
        {
            Score1 = resultScore
            highscoreLabel.text = NSString(format: "HighScore: %i",  Score1) as String
            let defaults = UserDefaults.standard
            defaults.setValue(Score1, forKey: "highscore")
            defaults.synchronize()
            
        }
        
        self.playButton.position=CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.playButton.size = CGSize(width: 100, height: 100)
        self.addChild(self.playButton)
        
        suggestion = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        suggestion.fontSize = 20
        suggestion.fontColor = SKColor.black
        suggestion.position = CGPoint(x: self.frame.midX, y: self.frame.midY-100)
        suggestion.text = "Tap to play"
        self.addChild(suggestion)
        
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addingMonsters),
                SKAction.wait(forDuration: 2.5)
                ])
        ))
    }
    
    
    func addingMonsters() {
        
        let monster = SKSpriteNode(imageNamed: "villan01")
        
        let f1 = SKTexture.init(imageNamed: "villan01")
        let f2 = SKTexture.init(imageNamed: "villan02")
        let f3 = SKTexture.init(imageNamed: "villan03")
        let f4 = SKTexture.init(imageNamed: "villan04")
        let f5 = SKTexture.init(imageNamed: "villan03")
        let f6 = SKTexture.init(imageNamed: "villan02")
        
        let frame: [SKTexture] = [f1, f2, f3, f4, f5, f6]
        
        let animation1 = SKAction.animate(with: frame, timePerFrame: 0.15)
        monster.run(SKAction.repeatForever(animation1))
        monster.size = CGSize(width: 60.0, height: 60.0)
        
        monster.position = CGPoint(x: self.frame.maxX  , y: self.frame.maxY)
        monster.zRotation = 180 * (Pi/180)
        monster.zPosition = 3
        addChild(monster)
        let actionMove = SKAction.move(to: CGPoint(x: self.frame.midX+165, y: self.frame.midY+160), duration: TimeInterval(3.0))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        
        let monster1 = SKSpriteNode(imageNamed: "villan01")
        monster1.run(SKAction.repeatForever(animation1))
        monster1.size = CGSize(width: 60.0, height: 60.0)
        monster1.position = CGPoint(x: self.frame.maxX  , y: self.frame.midY)
        monster1.zRotation = 135 * (Pi/180)
        monster1.zPosition = 3
        addChild(monster1)
        let actionMove1 = SKAction.move(to: CGPoint(x: self.frame.midX+165, y: self.frame.midY+160), duration: TimeInterval(3.0))
        let actionMoveDone1 = SKAction.removeFromParent()
        monster1.run(SKAction.sequence([actionMove1, actionMoveDone1]))
      
        
        let monster2 = SKSpriteNode(imageNamed: "villan01")
        monster2.run(SKAction.repeatForever(animation1))
        monster2.size = CGSize(width: 60.0, height: 60.0)
        monster2.position = CGPoint(x: self.frame.midX+100 , y: self.frame.minY)
        monster2.zRotation = 90*(Pi/180)
        monster2.zPosition = 3
        addChild(monster2)
        let actionMove2 = SKAction.move(to: CGPoint(x: self.frame.midX+135, y: self.frame.midY+160), duration: TimeInterval(3.0))
        let actionMoveDone2 = SKAction.removeFromParent()
        monster2.run(SKAction.sequence([actionMove2, actionMoveDone2]))
        
        
        let monster3 = SKSpriteNode(imageNamed: "villan01")
        monster3.run(SKAction.repeatForever(animation1))
        monster3.size = CGSize(width: 60.0, height: 60.0)
        monster3.position = CGPoint(x: self.frame.minX , y: self.frame.minY)
        monster3.zRotation = 45*(Pi/180)
        monster3.zPosition = 3
        addChild(monster3)
        let actionMove3 = SKAction.move(to: CGPoint(x: self.frame.midX+135, y: self.frame.midY+160), duration: TimeInterval(3.0))
        let actionMoveDone3 = SKAction.removeFromParent()
        monster3.run(SKAction.sequence([actionMove3, actionMoveDone3]))
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.playButton {
                let scene = GameScene(size: self.size)
                let skView = self.view as SKView!
                skView?.ignoresSiblingOrder = true
                scene.scaleMode = .fill
                scene.size = (skView?.bounds.size)!
                skView?.presentScene(scene)
            }
            
        }
    }
    
    
}
