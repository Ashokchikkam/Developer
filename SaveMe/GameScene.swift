//
//  GameScene.swift
//  SaveMe
//
//  Created by Ashok on 10/25/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import AVFoundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    
    let Pi = CGFloat(M_PI)
    
    let f1 = SKTexture.init(imageNamed: "villan01")
    let f2 = SKTexture.init(imageNamed: "villan02")
    let f3 = SKTexture.init(imageNamed: "villan03")
    let f4 = SKTexture.init(imageNamed: "villan04")
    let f5 = SKTexture.init(imageNamed: "villan03")
    let f6 = SKTexture.init(imageNamed: "villan02")
    
    let h1 = SKTexture.init(imageNamed: "hero01")
    let h2 = SKTexture.init(imageNamed: "hero02")
    
    let player = SKSpriteNode(imageNamed: "hero01")

    var monstersDestroyed = 0
    var interval = 0.5
    var bulletSpeed = 1500
    
    let pauseButton = SKSpriteNode(imageNamed:"pause")
    var pauseText = SKLabelNode(fontNamed: "chalkboardSE-Bold")
    // let pauseText = SKSpriteNode(imageNamed:"play")
    var scoreLabel = SKLabelNode()
    var scoreLabelNode = SKLabelNode()
    var Score: Int = 0
    
    var count = 3
    
    let life1 = SKSpriteNode(imageNamed:"star")
    let life2 = SKSpriteNode(imageNamed:"star")
    let life3 = SKSpriteNode(imageNamed:"star")
    
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideAd"), object: nil)
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))

        
        //Code for adding background Music
        let backgroundMusic = SKAudioNode(fileNamed: "background01.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
        backgroundColor = SKColor.white

        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.zPosition = 2
        
        let frames: [SKTexture] = [h1, h2 ]
        let animation = SKAction.animate(with: frames, timePerFrame: 0.50)
        player.run(SKAction.repeatForever(animation))
        
        player.size = CGSize(width: 50.0, height: 50.0)
        
        addChild(player)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        
        self.life1.position=CGPoint(x: self.frame.maxX-60, y: self.frame.maxY-20)
        self.life1.size = CGSize(width: 25, height: 25)
        self.life1.zPosition = 2
        self.addChild(self.life1)
        
        self.life2.position=CGPoint(x: self.frame.maxX-85, y: self.frame.maxY-20)
        self.life2.size = CGSize(width: 25, height: 25)
        self.life2.zPosition = 2
        self.addChild(self.life2)
        
        self.life3.position=CGPoint(x: self.frame.maxX-110, y: self.frame.maxY-20)
        self.life3.size = CGSize(width: 25, height: 25)
        self.life3.zPosition = 2
        self.addChild(self.life3)
        
        self.pauseButton.position=CGPoint(x: self.frame.maxX-30, y: self.frame.maxY-30)
        self.pauseButton.size = CGSize(width: 50, height: 50)
        self.pauseButton.zPosition = 2
        self.addChild(self.pauseButton)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.frame.minX+50, y: self.frame.maxY-30)
        scoreLabel.text = "Score:"
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        scoreLabelNode = SKLabelNode(fontNamed: "chalkboardSE-Bold")
        scoreLabelNode.fontSize = 30
        scoreLabelNode.fontColor = SKColor.black
        scoreLabelNode.position = CGPoint(x: self.frame.minX+140, y: self.frame.height-30)
        scoreLabelNode.text = "0"
        scoreLabelNode.zPosition = 2
        self.addChild(scoreLabelNode)
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: interval)
                ])
        ))
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        //let monster = SKSpriteNode(imageNamed: "monster")

        let monster = SKSpriteNode(imageNamed: "villan01")
        
        let frames: [SKTexture] = [f1, f2, f3, f4, f5, f6]
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.15)
        monster.run(SKAction.repeatForever(animation))
        
        let DegreesToRadians = Pi / 180

        monster.size = CGSize(width: 60.0, height: 60.0)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        
        monster.zPosition = 3
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine where to spawn the monster along the Y axis
        var actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        var actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        if(actualX > size.width/3 && actualX < size.width*(2/3)){
            actualX -= size.width
        }
        if(actualY > size.height/3 && actualY < size.height*(2/3)){
            actualY -= size.height
        }
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: actualY)
        
        // Add the monster to the scene
        
        let x = monster.position.x - size.width/2.0
        let y = monster.position.y - size.height/2.0
        
        let angle = atan2(y, x)
        
        //self.addMonster().zRotation = angle + DegreesToRadians
        
        monster.zRotation = angle + 180 * DegreesToRadians
        
        addChild(monster)
        
        
        Score = monstersDestroyed
        UserDefaults.standard.set(Score, forKey: "userScore")
        
        
        scoreLabelNode.text = "\(Score)"
        
        // Determine speed of the monster
        var actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        
        if(Score < 5){
            actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
            //interval = 1.8
        }
        
        if(Score >= 5 && Score < 10){
            actualDuration = random(min: CGFloat(2.8), max: CGFloat(3.5))
            interval = 1.0
            bulletSpeed = 1100
            
        }
        if(Score >= 10 && Score < 15){
            actualDuration = random(min: CGFloat(2.3), max: CGFloat(2.8))
            interval = 0.1
            bulletSpeed = 1200
            
        }
        if(Score >= 15 && Score < 25){
            actualDuration = random(min: CGFloat(1.8), max: CGFloat(2.2))
            interval = 0.1
            bulletSpeed = 1300
            
        }
        if(Score >= 25 && Score < 45){
            actualDuration = random(min: CGFloat(1.3), max: CGFloat(1.7))
            interval = 0.1
            bulletSpeed = 1400
        }
        if(Score >= 45 && Score < 60){
            actualDuration = random(min: CGFloat(1.3), max: CGFloat(1.7))
            interval = 0.1
            bulletSpeed = 1500
        }
        if(Score >= 60 && Score < 75){
            actualDuration = random(min: CGFloat(1.3), max: CGFloat(1.7))
            interval = 0.1
            bulletSpeed = 1600
        }
        if(Score >= 75 && Score < 90){
            actualDuration = random(min: CGFloat(1.0), max: CGFloat(1.3))
            interval = 0.1
            bulletSpeed = 1600
        }
        if(Score >= 90 && Score < 100){
            actualDuration = random(min: CGFloat(0.8), max: CGFloat(1.0))
            interval = 0.1
            bulletSpeed = 1600
        }
        if(Score >= 100 && Score < 120){
            actualDuration = random(min: CGFloat(1.0), max: CGFloat(1.3))
            interval = 0.1
            bulletSpeed = 1600
        }
        if(Score > 120){
            actualDuration = random(min: CGFloat(0.8), max: CGFloat(1.0))
            interval = 0.1
            bulletSpeed = 1600
        }
        // Create the actions
        // let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMove = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size)
            
            if(self.count == 3){
                self.life3.removeFromParent()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            if(self.count == 2){
                self.life2.removeFromParent()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            if(self.count == 1){
                self.life1.removeFromParent()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            if(self.count == 0){
                
                self.physicsWorld.contactDelegate = nil
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            self.count -= 1
        }
        
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
        
    }
    
    func pauseGame()
    {
        self.view!.isPaused = true // to pause the game
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let DegreesToRadians = Pi / 180

        //Adding the shooting sound
       // let shootMusic = SKAudioNode(fileNamed: "shoot02.mp3")

        
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        //if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        // code to rotate the mouse towards the touch location
        //let x = self.player.position.x - touchLocation.x
        //let y = self.player.position.y - touchLocation.y
        
        //let angle = atan2(y, x)
        
       // self.player.zRotation = angle +  DegreesToRadians

        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * CGFloat(bulletSpeed) as CGPoint
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        
        //shootMusic.autoplayLooped = true
        
        //addChild(shootMusic)
        
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        run(SKAction.playSoundFileNamed("shoot02.mp3", waitForCompletion: false))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            pauseText.text = "Resume"
            pauseText.fontColor = UIColor.black
            pauseText.fontSize =  100
            pauseText.position = CGPoint(x: self.frame.width/2  , y: self.frame.height/2)
            //pauseText.position = CGPoint(x: self.frame.maxX-60, y: self.frame.maxY-30)
            
            pauseText.zPosition = 3
            //let pauseButton = SKSpriteNode(imageNamed:"pause")
            let location = touch.location(in: self)
            if self.atPoint(location) == self.pauseButton {
                //manager.stopAccelerometerUpdates()
                //self.view?.isUserInteractionEnabled = false
                self.view?.alpha = 0.6
                addChild(pauseText) // add the resume
                //self.addChild(self.pauseText)
                pauseButton.removeFromParent ()  // to avoid error when you touch again
                self.run (SKAction.run(self.pauseGame))
                
                
            }
            if self.atPoint(location) == self.pauseText
            {
                //self.view?.isUserInteractionEnabled = true
                //manager.startAccelerometerUpdates()
                pauseText.removeFromParent() // remove the pause text
                self.view!.isPaused = false // resume the game
                addChild(pauseButton) // add the pause button
                self.view?.alpha = 1.0
                
            }
        }
        
    }
    
    func projectileDidCollideWithMonster(_ projectile:SKSpriteNode, monster:SKSpriteNode) {
        //print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            //print("hit")
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            

            
            //projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        monstersDestroyed += 1
        
        /*
         if (monstersDestroyed > 30) {
         let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
         let gameOverScene = GameOverScene(size: self.size, won: true)
         self.view?.presentScene(gameOverScene, transition: reveal)
         }
         */
        
    }
    
    
}
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}
