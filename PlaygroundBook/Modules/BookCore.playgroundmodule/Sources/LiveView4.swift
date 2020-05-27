//
//  GameScene3.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 14/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

//: A SpriteKit based Playground

import SpriteKit
import UIKit
import PlaygroundSupport
import GameplayKit
import AVFoundation


public class LiveView4: SKScene {
    
    public var backgroundPlayer: AVAudioPlayer!
    public var blackHoles : [FSMState] = []
    
    public var isFirstTap: Bool = true
    public var currentState: FSMLogic.StatesPG3 = FSMLogic.StatesPG3.first
    public var deltaY: CGFloat = -40.0
    public var ball: SKShapeNode!
    public var dirArrow: FSMLine!
    
    private var ballPath: CGPath!
    private var ballPathInversed: CGPath!
    
    private var colors: [UIColor] = [UIColor(hexString: "#010026"),
                                     UIColor(hexString: "#413066"),
                                     UIColor.white].reversed()
    public var stateCount:Int = 2
    
    // MARK: - User Interaction

    // THIS WILL CHANGE
    // reduce to make it faster
    public var durationBallMove: Double = 6.0
    
    // THIS WILL CHANGE
    // reduce to make it slower
    public var speedBallMovement: CGFloat = 0.6
    
    public var isAimHidden: Bool = false
    
    public var blackHoleSpeed: CGFloat = 180.0
    
    public var ballClockwise: Bool = true
    
    public var backgroundSprite: SKSpriteNode!
    
    public var endNode: SKShapeNode!
    public var physicsBodyEndNode: SKPhysicsBody!
    
    
    // MARK: - Functions
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setSound()
        self.setupBackground()
        self.setEndNode()
        self.ballBase()
        self.setupBall()
        self.setHoles()
        self.physicsWorld.contactDelegate = self
        
        rotateCloserBlackHoles()
        rotateFurtherBlackHoles()
    }
 
    public func setHoles() {
        let holeNode1 = FSMState(
                            side: 40,
                            position: CGPoint.zero,
                            name: "holeNode1",
                            style: .page3)
        holeNode1.zPosition = -3
        holeNode1.position = CGPoint(x: -50, y: 160 + deltaY)
        holeNode1.setPhysicsBody(forceField: true)
        self.addChild(holeNode1)
        blackHoles.append(holeNode1)
        
        let holeNode2 = FSMState(
                            side: 50,
                            position: CGPoint.zero,
                            name: "holeNode2",
                            style: .page3)
        holeNode2.zPosition = -3
        holeNode2.position = CGPoint(x: 120, y: 0 + deltaY)
        holeNode2.setPhysicsBody(forceField: true)
        self.addChild(holeNode2)
        blackHoles.append(holeNode2)
        
        let holeNode3 = FSMState(
                            side: 40,
                            position: CGPoint.zero,
                            name: "holeNode3",
                            style: .page3)
        holeNode3.zPosition = -4
        holeNode3.position = CGPoint(x: -80.0, y: 60.0 + deltaY)
        holeNode3.setPhysicsBody(forceField: true)
        self.addChild(holeNode3)
        blackHoles.append(holeNode3)
        
        let holeNode4 = FSMState(
                            side: 45,
                            position: CGPoint.zero,
                            name: "holeNode4",
                            style: .page3)
        holeNode4.zPosition = -4
        holeNode4.position = CGPoint(x: 50.0, y: 100.0 + deltaY)
        holeNode4.setPhysicsBody(forceField: true)
        self.addChild(holeNode4)
        blackHoles.append(holeNode4)
        
        let holeNode5 = FSMState(
                            side: 50,
                            position: CGPoint.zero,
                            name: "holeNode5",
                            style: .page3)
        holeNode5.zPosition = -4
        holeNode5.position = CGPoint(x: 0.0, y: -20.0 + deltaY)
        holeNode5.setPhysicsBody(forceField: true)
        self.addChild(holeNode5)
        blackHoles.append(holeNode5)
        
        
        let holeNode6 = FSMState(
                            side: 50,
                            position: CGPoint.zero,
                            name: "holeNode6",
                            style: .page3)
        holeNode6.zPosition = -4
        holeNode6.position = CGPoint(x: -90.0, y: -70.0 + deltaY)
        holeNode6.setPhysicsBody(forceField: true)
        self.addChild(holeNode6)
        blackHoles.append(holeNode6)
        
    }
    
    public func rotateFurtherBlackHoles() {
        blackHoles[0].rotate(
            center: CGPoint(x: -10.0 , y: 0.0),
            clockwise: true,
            angleStart: .pi/3,
            speed: blackHoleSpeed*3)
        
        blackHoles[1].rotate(
            center: CGPoint(x: -10.0, y: 0.0),
            clockwise: true,
            angleStart: -.pi/3,
            speed: blackHoleSpeed*3)
            
        blackHoles[5].rotate(
            center: CGPoint(x: -10.0, y: 0.0),
            clockwise: true,
            angleStart: .pi*1.1,
            speed: blackHoleSpeed*3)
    }
    
    public func rotateCloserBlackHoles() {
        
        blackHoles[2].rotate(
            center: CGPoint(x: 0.0, y: 0.0),
            clockwise: false,
            angleStart: .pi/3,
            speed: blackHoleSpeed*0.7)
        
        blackHoles[3].rotate(
            center: CGPoint(x: 0.0, y: 0.0),
            clockwise: false,
            angleStart: -.pi/3,
            speed: blackHoleSpeed*0.7)
      
        blackHoles[4].rotate(
            center: CGPoint(x: 0.0, y: 0.0),
            clockwise: false,
            angleStart: .pi*1.1,
            speed: blackHoleSpeed*0.7)
    }
    
    public func ballBase() {
        let size: CGFloat = 250.0*2
        
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: -size/2.0, y: -size/2, width: size, height: size))
        
        let invertedPath = bezierPath.reversing()
        invertedPath.apply(CGAffineTransform.init(rotationAngle: -.pi/2.0))
        
        self.ballPathInversed = invertedPath.cgPath
        bezierPath.apply(CGAffineTransform.init(rotationAngle: -.pi/2.0))
        let pattern : [CGFloat] = [5.0, 20.0]
        let dashedPath = bezierPath.cgPath.copy(dashingWithPhase: 5.0, lengths: pattern)
 
        self.ballPath = bezierPath.cgPath
        let shapeNode = SKShapeNode(path: dashedPath)
        shapeNode.strokeColor = UIColor.white.withAlphaComponent(0.3)
        shapeNode.position = CGPoint(x: 0.0, y: 0.0)
        shapeNode.lineWidth = 3.0
        self.addChild(shapeNode)
        
    }
    
    
    public func setupBall() {
        
        // ball
        
        let radius: CGFloat = 11.0
        ball = SKShapeNode(circleOfRadius: radius)
        ball.position = CGPoint(x: 0.0, y:  -220.0)
        ball.fillColor = colors[stateCount]
        ball.strokeColor = UIColor.lightGray.withAlphaComponent(0.15)
        ball.lineWidth = 4
        
        ball.name = "ball"
        
        self.addChild(ball)
        //  ball.run(repeatForever)
        
        // let sequenceRotating = SKAction.sequence([rotate, rotateBack, rotateZero])
        //let sequenceMoving = SKAction.sequence([moveAction, moveActionLeft, moveActionZero])
        let pathBall: CGPath = self.ballClockwise ? self.ballPath : self.ballPathInversed
        
        let move = SKAction.follow(pathBall, asOffset: false, orientToPath: true, duration: durationBallMove)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        ball.physicsBody?.categoryBitMask = 0
        ball.physicsBody?.contactTestBitMask = 1 | 2
        ball.physicsBody?.collisionBitMask = 1 | 2
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.fieldBitMask = 1
        
        if !isAimHidden {
           
            let lambda: CGFloat = self.ballClockwise ? -1 : 1
            // arrow direction
            dirArrow = FSMLine(
                from: CGPoint(x: 0.0, y: 0),
                to: CGPoint(x: lambda*90.0, y: 0),
                headSize: 10.0,  name: "lineDir",
                style: .page1)
            dirArrow.body.strokeColor = colors[stateCount].withAlphaComponent(0.1)
            dirArrow.body.fillColor = colors[stateCount].withAlphaComponent(0.30)
            dirArrow.position = CGPoint(x: 0.0, y: 0.0)
            dirArrow.glowBody.fillColor = colors[stateCount].withAlphaComponent(0.1)
            dirArrow.glowBody.strokeColor = colors[stateCount].withAlphaComponent(0.1)
            dirArrow.alpha = 0.0
            dirArrow.zPosition = -1
            ball.addChild(dirArrow)
            
            dirArrow.run(SKAction.sequence([.wait(forDuration: 0.3), .fadeIn(withDuration: 0.3)]))
        
        }
        
        ball.run(SKAction.repeatForever(move), withKey: "horizontalMove")
        
    }
    
    public func setEndNode() {
        let endNodeSize: CGFloat = 35.0
        
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: -endNodeSize/2.0, y: -endNodeSize/2.0, width: endNodeSize, height: endNodeSize))
        
        let endNodeSize2: CGFloat = endNodeSize + endNodeSize/5.0
        let bezierPath2 = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: endNodeSize2, height: endNodeSize2))

        let underEndNode = SKShapeNode(path: bezierPath2.cgPath)
        underEndNode.position = CGPoint(x: -endNodeSize2/2.0, y: -endNodeSize2/2.0)
        underEndNode.fillColor = UIColor.gray.withAlphaComponent(0.2)
        underEndNode.strokeColor = UIColor.clear
        
        endNode = SKShapeNode(path: bezierPath.cgPath)
        endNode.addChild(underEndNode)
        
        endNode.fillColor = UIColor.white
        endNode.strokeColor = UIColor.lightGray.withAlphaComponent(0.2)
        endNode.lineWidth = 6
        endNode.position = CGPoint(x: 0.0, y: 0.0)
        endNode.name = "endNode"
        self.addChild(endNode)
        
        physicsBodyEndNode = SKPhysicsBody(circleOfRadius: endNodeSize/2.0)
        physicsBodyEndNode.categoryBitMask = 2
        physicsBodyEndNode.contactTestBitMask = 0
        physicsBodyEndNode.collisionBitMask = 0
        physicsBodyEndNode.affectedByGravity = false
        physicsBodyEndNode.fieldBitMask = 0
        endNode.physicsBody = physicsBodyEndNode
    }
    
    public func setupBackground() {
        backgroundSprite = SKSpriteNode()
        backgroundSprite.texture = SKTexture(imageNamed: "bk.jpg")
       // backgroundSprite.colorBlendFactor = 1
        backgroundSprite.alpha = 0.15//UIColor(hexString: "#E4DED3").withAlphaComponent(0.15)
        backgroundSprite.size = CGSize(width: 1400*1.0, height: 880*1.0)
        backgroundSprite.position = CGPoint(x: 0.0, y: 0.0)
        backgroundSprite.zPosition = -100
        backgroundSprite.name = "background"
        self.addChild(backgroundSprite)
        
        let actionScale = SKAction.scale(by: 1.015, duration: 2.0)
        let repeatAction = SKAction.repeatForever(SKAction.sequence([actionScale, actionScale.reversed()]))
        backgroundSprite.run(repeatAction)
    }
    
    public func setSound() {
        
        let sound = "Thinking_About_It.mp3"
        
        let path = Bundle.main.path(forResource: sound, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer.volume = 0.4
            backgroundPlayer?.play()
            backgroundPlayer?.numberOfLoops = -1
        } catch {
            // couldn't load file :(
        }
    }
    
    
    public func moveCamera() {
        if let camera = self.scene!.camera {
            let scale = SKAction.scaleX(by: 1.03, y: 1.03, duration: 0.3)
            
            camera.run(scale)
        }
    }
    
    public func setParticles() {
        if let rp = SKEmitterNode(fileNamed: "ParticlePG1.sks") {
            rp.position = .zero
            rp.targetNode = scene
            scene!.addChild(rp)
        }
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    
    public func touchDown(atPoint pos : CGPoint) {
       
        if isFirstTap {
            
            isFirstTap = false
        }
        
        let dx = -(ball.position.x - 0.0)*speedBallMovement
        let dy = -(ball.position.y - 20.0)*speedBallMovement
        print(dx)
        print(dy)
        
        let moveAction = SKAction.applyForce(CGVector(dx: dx, dy: dy), duration: 0.1)
        let scaleDown = SKAction.scale(by: 0.5, duration: TimeInterval(2/speedBallMovement))
        ball.removeAllActions()
        ball.run(SKAction.group([moveAction, scaleDown])) {
            self.ball.removeFromParent()
            self.setupBall()
        }
        dirArrow.removeFromParent()
    }
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    
    func playWinSound() {
        let sound = "winSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        
        self.run(playSound)
    }
}

extension LiveView4: SKPhysicsContactDelegate {
    
    public func orderNodes(nodeA: SKNode, nodeB: SKNode) -> (first: SKNode, second: SKNode){
        if(nodeA.physicsBody!.categoryBitMask < nodeB.physicsBody!.categoryBitMask){
            return (first: nodeA, second: nodeB)
        }
        return (first: nodeB, second: nodeA)
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nA = contact.bodyA.node, var nameA = nA.name else {return}
        guard let nB = contact.bodyB.node, var nameB = nB.name else {return}
        
        let nodes = orderNodes(nodeA: nA, nodeB: nB)
        let nodeA = nodes.first
        let nodeB = nodes.second
        nameA = nodeA.name!
        nameB = nodeB.name!
        
        if nameA == "ball" {
            if nameB == "endNode" {
                self.ball.physicsBody = nil
                playWinSound()
            } else {
            }
        } else if nameA == "endNode" {
            self.ball.physicsBody = nil
            playWinSound()
        } else if nameA.hasPrefix("hole") {
            print("C")
        }
       // self.ball.physicsBody = nil
        self.ball.physicsBody?.contactTestBitMask = 2
        self.ball.removeAllActions()
        
        let action = SKAction.scale(by: 0.0, duration: 0.35)
        
        self.ball.run(action) {[weak self] in
            self?.ball.removeFromParent()
            self?.setupBall()
        }
           
        print(nameA)
        print(nameB)
    }
    
}


public class LiveView4Controller: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
        if let scene = LiveView4(fileNamed: "LiveView4") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            sceneView.presentScene(scene)
            
        }
        self.view = sceneView
    }

}
