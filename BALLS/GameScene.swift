//
//  GameScene.swift
//  BALLS
//
//  Created by Ryan Maksymic on 2018-02-17.
//  Copyright © 2018 Ryan Maksymic. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene
{
  // MARK: - Properties
  
  var gameOn = false
  var motionManager : CMMotionManager!
  var cameraTimer: Timer!
  var ball: SKSpriteNode!
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()
  private var lastUpdateTime : TimeInterval = 0
  
  
  // MARK: - Setup
  
  override func sceneDidLoad()
  {
    setUpMotionManager()
    
    setUpCamera()
    
    setUpBall()
    
    //self.physicsWorld.gravity = CGVector(dx: 0, dy: -30.0)
    
    self.lastUpdateTime = 0
  }
  
  func setUpMotionManager()
  {
    motionManager = CMMotionManager()
    
    motionManager.startAccelerometerUpdates()
  }
  
  func setUpCamera()
  {
    let backgroundHeight = CGFloat(3840)
    let backgroundCount = CGFloat(2)
    
    let cameraYLowerLimit = -backgroundHeight * (backgroundCount - 0.5)
    
    camera?.position = CGPoint(x: 0.0, y: 0.0)
    
    let cameraXConstraint = SKConstraint.positionX(SKRange(lowerLimit: 0.0, upperLimit: 0.0))
    let cameraYConstraint = SKConstraint.positionY(SKRange(lowerLimit: cameraYLowerLimit, upperLimit: 0.0))
    
    camera?.constraints = [cameraXConstraint, cameraYConstraint]
  }
  
  func setUpBall()
  {
    ball = self.childNode(withName: "ball") as! SKSpriteNode
    ball.physicsBody?.isDynamic = false
  }
  
  
  // MARK: - Touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
  {
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    // TODO: Jump!
    
    switch gameOn
    {
    case false:
      //      cameraTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { (timer) in
      //        self.camera?.position.y -= 3
      //      }
      ball.physicsBody?.isDynamic = true
      gameOn = true
    default:
      //cameraTimer.invalidate()
      ball.physicsBody?.isDynamic = false
      gameOn = false
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
  {
  }
  
  
  // MARK: - Update
  
  override func update(_ currentTime: TimeInterval)
  {
    updateGravity()
    
    // Initialize _lastUpdateTime if it has not already been:
    if (self.lastUpdateTime == 0)
    {
      self.lastUpdateTime = currentTime
    }
    
    // Calculate time since last update:
    let dt = currentTime - self.lastUpdateTime
    
    // Update entities:
    for entity in self.entities
    {
      entity.update(deltaTime: dt)
    }
    
    self.lastUpdateTime = currentTime
  }
  
  func updateGravity()
  {
    if let accelerometerData = motionManager.accelerometerData
    {
      physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: -50)
    }
  }
}
