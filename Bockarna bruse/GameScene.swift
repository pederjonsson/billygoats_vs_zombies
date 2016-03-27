//
//  GameScene.swift
//  Bockarna bruse
//
//  Created by Morten Faarkrog on 08/09/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Instance Variables
    
    let zombieSpeed: CGFloat = 50.0
    var goal: SKSpriteNode?
    var scoredGoal = false
    var player: Player!
    var commentator:Commentator?
    var gameStatus:GameStatus?
    var playerGoats: [PlayerGoat] = []
    var zombies: [SKSpriteNode] = []
    var goals: [SKSpriteNode] = []
    var ball: SKSpriteNode!
    var lastTouch: CGPoint? = nil
    var scoreLabel:UILabel!
    
    // MARK: - SKScene
    
    override func didMoveToView(view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        
        
        // Setup player
        player = self.childNodeWithName("player") as? Player
        ball = self.childNodeWithName("ball") as! SKSpriteNode
       
        //the sound is relative to where the player is
        self.listener = player
        
        // Setup zombies
        for child in self.children {
            if child.name == "zombie" {
                if let child = child as? SKSpriteNode {
                    
                    //kind of funny sound but annoying after a while
                    // Add SKAudioNode to zombie
                    //let audioNode: SKAudioNode = SKAudioNode(fileNamed: "fear_moan.wav")
                    //child.addChild(audioNode)
                    
                    zombies.append(child)
                }
            }
            else if child.name == "playerGoat" {
                if let child:PlayerGoat = child as? PlayerGoat {
                    playerGoats.append(child)
                    if(playerGoats.count > 1){
                        //change to pass in speed in constructor instead
                        child.normalSpeed = 150
                    }
                }
            }
            //goals is the goal sprites, if ball hits it, register a score for either team
            else if child.name == "goal" {
                if let child = child as? SKSpriteNode {
                    goals.append(child)
                }
            }
        }
        
        // Setup initial camera position
        updateCamera()
        
        commentator = Commentator()
        commentator!.presentGame()
        
        //setup gamestatus
        gameStatus = GameStatus(scoreLabel: scoreLabel)
       
    }
    
    
    // MARK: Touch Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(touches: Set<UITouch>) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
    }
    
    
    // MARK - Updates
    override func didSimulatePhysics() {
        if(!scoredGoal){
            if let _ = player {
                updatePlayer()
                updatePlayerGoats()
                updateZombies()
            }
        }
    }
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
    }
    
    // Updates the player's position by moving towards the last touch made
    func updatePlayer() {
        if let touch = lastTouch {
            let currentPosition = player!.position
            if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
                
                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
                let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
                
                player!.runAction(rotateAction)
                
                let velocotyX = (player?.playerSpeed)! * cos(angle)
                let velocityY = (player?.playerSpeed)! * sin(angle)
                
                let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
                player!.physicsBody!.velocity = newVelocity;
                updateCamera()
            } else {
                player!.physicsBody!.resting = true
            }
        }
    }
    
    // make camera start where player is
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
        }
    }
    
    // Updates the position of all zombies by moving towards whatever is closest
    func updateZombies() {
        let playerGoat1 = playerGoats[0]
        let playerGoat2 = playerGoats[1]
        
        for zombie in zombies {
            let currentPosition = zombie.position
            
            // get the distance from two small goats, the ball and the player goat and
            // make the zombies chase whatever is closest
            let dx1:CGFloat = currentPosition.x - playerGoat1.position.x;
            let dy1:CGFloat = currentPosition.y - playerGoat1.position.y;
            
            let dx2:CGFloat = currentPosition.x - playerGoat2.position.x;
            let dy2:CGFloat = currentPosition.y - playerGoat2.position.y;
            
            let dx3:CGFloat = currentPosition.x - ball.position.x;
            let dy3:CGFloat = currentPosition.y - ball.position.y;
            
            let dx4:CGFloat = currentPosition.x - player.position.x;
            let dy4:CGFloat = currentPosition.y - player.position.y;
            
            let distance1:CGFloat = sqrt(dx1*dx1+dy1*dy1);
            let distance2:CGFloat = sqrt(dx2*dx2+dy2*dy2);
            let distance3:CGFloat = sqrt(dx3*dx3+dy3*dy3);
            let distance4:CGFloat = sqrt(dx4*dx4+dy4*dy4);
            
            var targetPosition:CGPoint
            
            if(distance1 >= distance2){
                if(distance2 >= distance3){
                    if(distance3 >= distance4){
                        targetPosition = player.position
                    }
                    else{
                        targetPosition = ball.position
                    }
                }
                else{
                    if(distance2 >= distance4){
                        targetPosition = player.position
                    }
                    else{
                        targetPosition = playerGoat2.position
                    }
                }
            }
            else{
                if(distance1 >= distance3){
                    if(distance3 >= distance4){
                        targetPosition = player.position
                    }
                    else{
                        targetPosition = ball.position
                    }
                }
                else{
                    if(distance1 >= distance4){
                        targetPosition = player.position
                    }
                    else{
                        targetPosition = playerGoat1.position
                    }
                }
            }
            
            let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            zombie.runAction(rotateAction)
            
            let velocotyX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            zombie.physicsBody!.velocity = newVelocity;
            
        }
        
        
    }
    
    // Updates the position of all smaller goats by moving towards the ball
    func updatePlayerGoats() {
        
        let targetPosition = ball!.position
        
        for playerGoat in playerGoats {
            let currentPosition = playerGoat.position
            
            let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            playerGoat.runAction(rotateAction)
            
            let velocotyX = playerGoat.normalSpeed * cos(angle)
            let velocityY = playerGoat.normalSpeed * sin(angle)
            
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            playerGoat.physicsBody!.velocity = newVelocity;
        }
        
    }
    
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(!scoredGoal){
            
            // 1. Create local variables for two physics bodies
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            
            // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            //handle goal scored
            if firstBody.categoryBitMask == ball?.physicsBody?.categoryBitMask &&
                secondBody.categoryBitMask == goals[0].physicsBody?.categoryBitMask {
                    
                    if(goals[0].physicsBody?.node === secondBody.node){
                        gameStatus?.goalScoredByZombies()
                        commentator?.goalByZombies()
                    }
                    else {
                        gameStatus?.goalScoredByGoats()
                        commentator?.goalByGoats()
                    }
                    
                    // this should stop game and rearrange players for kickoff again
                    scoredGoal = true
                    
                    //this should end game if time is up i guess?
                    gameOver(true)
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func gameOver(didWin: Bool) {
        print("- - - Game Ended - - -")
        //TODO: implement menuscene
        
        // let menuScene = MenuScene(size: self.size)
        //menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        //let transition = SKTransition.flipVerticalWithDuration(1.0)
        //menuScene.scaleMode = SKSceneScaleMode.AspectFill
        //self.scene!.view?.presentScene(menuScene, transition: transition)
    }
    
}
