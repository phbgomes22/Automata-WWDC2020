//
//  LiveView3.swift
//  BookCore
//
//  Created by Pedro Gomes on 16/05/20.
//
//: A SpriteKit based Playground

import SpriteKit
import UIKit
import PlaygroundSupport
import GameplayKit
import AVFoundation


public class LiveView3: SKScene {
    
    public var backgroundPlayer: AVAudioPlayer!
    public var states : [FSMState] = []
    public var lines : [FSMLine] = []
    
    public var deltaY: CGFloat = -40.0
    public var ball: SKShapeNode!
    public var dirArrow: FSMLine!
    
    private var ballPath: CGPath!
    
    // MARK: - User Interaction
    
    // THIS WILL CHANGE
    // reduce to make it slower
    public var speedBallMovement: CGFloat = 0.6
    
    public var isAimHidden: Bool = false
    
    public var ballClockwise: Bool = true
    
    public var backgroundSprite: SKSpriteNode!
    
    // MARK: - Functions
    
    private var colors: [UIColor] = [UIColor(hexString: "#010026"),
                                     UIColor(hexString: "#413066"),
                                     UIColor.white].reversed()
    public var stateCount:Int = 0
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        self.setSound()
        self.setupBackground()
        self.ballBase()
        self.setupBall()
    }
    
    public func ballBase() {
        let size: CGFloat = 250.0*2
        
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: -size/2.0, y: -size/2, width: size, height: size))
        
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
        let pathBall: CGPath = self.ballPath
        
        let move = SKAction.follow(pathBall, asOffset: false, orientToPath: true, duration: 9.0)
        
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
    
    public func setupBackground() {
        backgroundSprite = SKSpriteNode()
        
        let image = UIImage(named: "bk.jpg")!.noir!
        backgroundSprite.texture = SKTexture(image: image)
        backgroundSprite.alpha = 0.20//UIColor(hexString: "#E4DED3").withAlphaComponent(0.15)
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
            backgroundPlayer.numberOfLoops = -1
        } catch {
            // couldn't load file :(
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
       
        let dx = -(ball.position.x - 0.0)*speedBallMovement
        let dy = -(ball.position.y - 20.0)*speedBallMovement
        print(dx)
        print(dy)
        
        let moveAction = SKAction.applyForce(CGVector(dx: dx, dy: dy), duration: 0.1)
        let scaleDown = SKAction.scale(by: 0.5, duration: 0.7)
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
    
    
    public func setupBoard() {
        self.setupTopStates()
        self.setupLines()
    }
    
    public func setupTopStates() {
        
        let spacingX: CGFloat = 50.0
        let yPos: CGFloat = 300.0
        
        let state1 = FSMState(
                        side: 50,
                        position: CGPoint(x: -3*spacingX, y: yPos + deltaY),
                        name: "state1",
                        style: .normal)
        self.addChild(state1)
        state1.setOutput(text: "I", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state1.holder.lineWidth = 2.0
        state1.alpha = 0.25
        states.append(state1)
        
        let state2 = FSMState(
                        side: 50,
                        position: CGPoint(x: -1*spacingX, y: yPos + deltaY),
                        name: "state2",
                        style: .normal)
        self.addChild(state2)
        state2.setOutput(text: "II", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state2.holder.lineWidth = 2.0
        state2.alpha = 0.25
        states.append(state2)
        
        let state3 = FSMState(
                        side: 50,
                        position: CGPoint(x: 1*spacingX, y: yPos + deltaY),
                        name: "state3",
                        style: .normal)
               
        self.addChild(state3)
        state3.setOutput(text: "III", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state3.holder.lineWidth = 2.0
        state3.alpha = 0.25
        states.append(state3)
        
        
        let state4 = FSMState(
                        side: 50,
                        position: CGPoint(x: 3*spacingX, y: yPos + deltaY),
                        name: "state4",
                        style: .normal)
               
        self.addChild(state4)
        state4.setOutput(text: "🏆", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state4.holder.lineWidth = 2.0
        state4.alpha = 0.25
        states.append(state4)
    }
    
    public func setupLines() {
        let line1 = FSMLine(
                        from: states[0].edgePosition(at: 0.0),
                        to: states[1].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        headSize: 12.0, name: "line1",
                        style: .normal)
        self.addChild(line1)
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[1].edgePosition(at: 0.0),
                        to: states[2].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        headSize: 12.0,  name: "line2",
                        style: .normal)
        self.addChild(line2)
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[2].edgePosition(at: 0.0),
                        to: states[3].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        headSize: 12.0,  name: "line3",
                        style: .normal)
        self.addChild(line3)
        lines.append(line3)
        
    }
    
    
}


public class LiveView3Controller: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
        if let scene = LiveView3(fileNamed: "LiveView3") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            sceneView.presentScene(scene)
            
        }
        self.view = sceneView
    }

}
