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
//import PlaygroundSupport
import GameplayKit


public class GameScene3: SKScene {
    
    public var states : [FSMState] = []
    public var lines : [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var currentState: FSMLogic.StatesPG3 = FSMLogic.StatesPG3.first
    public var deltaY: CGFloat = -50.0
    public var ball: SKShapeNode!
    public var dirArrow: FSMLine!
    
    private var ballPath: CGPath!
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.prepareSound()
        self.setParticles()
        self.setupBoard()
        //self.setSound()
        self.setupBackground()
        self.setEndNode()
        self.ballBase()
        self.setupBall()
        self.setHoles()
       // self.view?.showsFields = true
        self.physicsWorld.contactDelegate = self
        
    }
    
    // ADD THIS TO OTHERS TOO
    public func prepareSound() {

        let audio = SKAudioNode(fileNamed: "7b-a1")
        audio.autoplayLooped = false
        self.addChild(audio)
        audio.run(SKAction.changeVolume(to: 0.0, duration: 0.0)) {
            audio.removeFromParent()
        }
    }
 
    
    public func setHoles() {
        let holeNode1 = FSMState(
                            side: 40,
                            position: CGPoint.zero,
                            name: "holeNode1",
                            style: .page3)
        holeNode1.zPosition = -3
        holeNode1.position = CGPoint(x: -70, y: -50 + deltaY)
        holeNode1.setPhysicsBody(forceField: true)
        self.addChild(holeNode1)
        
        let holeNode2 = FSMState(
                            side: 50,
                            position: CGPoint.zero,
                            name: "holeNode2",
                            style: .page3)
        holeNode2.zPosition = -3
        holeNode2.position = CGPoint(x: 120, y: 110 + deltaY)
        holeNode2.setPhysicsBody(forceField: true)
        self.addChild(holeNode2)
        
        
        let holeNode3 = FSMState(
                            side: 40,
                            position: CGPoint.zero,
                            name: "holeNode2",
                            style: .page3)
        holeNode3.zPosition = -4
        holeNode3.position = CGPoint(x: -100.0, y: 60.0 + deltaY)
        holeNode3.setPhysicsBody(forceField: true)
        self.addChild(holeNode3)
        
        holeNode1.rotate(center: CGPoint(x: 80.0 , y: 40.0), clockwise: true)
        holeNode2.rotate(center: CGPoint(x: -30.0, y: -20.0), clockwise: false)
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
        
        let radius: CGFloat = 14.0
        ball = SKShapeNode(circleOfRadius: radius)
        ball.position = CGPoint(x: 0.0, y:  -220.0)
        ball.fillColor = UIColor.white
        ball.strokeColor = UIColor.lightGray.withAlphaComponent(0.15)
        ball.lineWidth = 4
        let scaleBall = SKAction.scale(by: 1.1, duration: 0.6)
        let repeatForever = SKAction.repeatForever(.sequence([scaleBall, scaleBall.reversed()]))
        ball.name = "ball"
        
        self.addChild(ball)
        //  ball.run(repeatForever)
        
        
        let durationMove: Double = 10.0
        
        // let sequenceRotating = SKAction.sequence([rotate, rotateBack, rotateZero])
        //let sequenceMoving = SKAction.sequence([moveAction, moveActionLeft, moveActionZero])
        let move = SKAction.follow(self.ballPath, asOffset: false, orientToPath: true, duration: durationMove)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        ball.physicsBody?.categoryBitMask = 0
        ball.physicsBody?.contactTestBitMask = 1 | 2
        ball.physicsBody?.collisionBitMask = 1 | 2
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.fieldBitMask = 1
        
        // arrow direction
        dirArrow = FSMLine(
            from: CGPoint(x: 0.0, y: 0),
            to: CGPoint(x: -80.0, y: 0),
            headSize: 10.0,  name: "lineDir",
            style: .page1)
        dirArrow.body.strokeColor = UIColor.white.withAlphaComponent(0.1)
        dirArrow.body.fillColor = UIColor.white.withAlphaComponent(0.30)
        dirArrow.position = CGPoint(x: 0.0, y: 0.0)
        dirArrow.glowBody.fillColor = UIColor.white.withAlphaComponent(0.1)
        dirArrow.glowBody.strokeColor = UIColor.white.withAlphaComponent(0.1)
        dirArrow.alpha = 0.0
        dirArrow.zPosition = -1
        ball.addChild(dirArrow)
        
        dirArrow.run(SKAction.sequence([.wait(forDuration: 0.3), .fadeIn(withDuration: 0.3)]))
        
        
        ball.run(SKAction.repeatForever(move), withKey: "horizontalMove")
        
    }
    
    public func setEndNode() {
        var endNodeSize: CGFloat = 40.0
        
        let bezierPath = UIBezierPath(ovalIn: CGRect(x: -endNodeSize/2.0, y: -endNodeSize/2.0, width: endNodeSize, height: endNodeSize))
        
        var endNodeSize2: CGFloat = endNodeSize + endNodeSize/5.0
        let bezierPath2 = UIBezierPath(ovalIn: CGRect(x: -endNodeSize2/2.0, y: -endNodeSize2/2.0, width: endNodeSize2, height: endNodeSize2))

        let underEndNode = SKShapeNode(path: bezierPath2.cgPath)
        underEndNode.fillColor = UIColor.gray.withAlphaComponent(0.2)
        underEndNode.strokeColor = UIColor.clear
        underEndNode.position = CGPoint(x: 0.0, y: 00.0)
        self.addChild(underEndNode)
        
        let endNode = SKShapeNode(path: bezierPath.cgPath)
        endNode.fillColor = UIColor.white
        endNode.strokeColor = UIColor.lightGray.withAlphaComponent(0.2)
        endNode.lineWidth = 6
        endNode.position = CGPoint(x: 0.0, y: 00.0)
        endNode.name = "endNode"
        self.addChild(endNode)
        
        
//        dashed.position = CGPoint(x: 0.0, y: 00.0)
//        self.addChild(dashed)
        
        endNode.physicsBody = SKPhysicsBody(circleOfRadius: endNodeSize/2.5)
        endNode.physicsBody?.categoryBitMask = 2
        endNode.physicsBody?.contactTestBitMask = 0
        endNode.physicsBody?.collisionBitMask = 0
        endNode.physicsBody?.affectedByGravity = false
        endNode.physicsBody?.fieldBitMask = 0
    }
    
    public func fireworks() {
        
        let sound = "winSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        DispatchQueue.main.async {
            self.run(playSound)

          //  PlaygroundPage.current.assessmentStatus = .pass(message: " **Great!** When you're ready, go to the [**Next Page**](@next)!")
        }
        DispatchQueue.global(qos: .userInteractive).async {
            
            var arrayFireworks = [CGPoint(x: -200.0, y: 300.0),
                                  CGPoint(x: 180.0, y: 240.0),
                                  CGPoint(x: 70.0, y: -240.0),
                                  CGPoint(x: -90.0, y: -10.0)]
            
           var arrayColors: [UIColor] = [UIColor(hexString: "#511845"),
                                                UIColor(hexString: "#900c3f"),
                                                UIColor(hexString: "#c70039"),
                                                UIColor(hexString: "#ff5733")]
            
            arrayColors += arrayColors.reversed()
            arrayFireworks += arrayFireworks
            
            for i in 0...(arrayFireworks.count/2 - 1) {
                if let rp = SKEmitterNode(fileNamed: "Firework.sks") {
                    rp.position = arrayFireworks[i*2]
                    rp.targetNode = self.scene
                    rp.particleColor = arrayColors[i*2]
                    rp.particleColorBlendFactor = 1.0
                    rp.particleColorSequence = nil

                    DispatchQueue.main.async {
                        self.scene!.addChild(rp)
                    }
                    usleep(150000)
                    
                    let aa = rp.copy() as! SKEmitterNode
                    aa.position = arrayFireworks[i*2 + 1]
                    aa.particleColor = arrayColors[i*2 + 1]
                    aa.targetNode = self.scene
                    DispatchQueue.main.async {
                        self.scene!.addChild(aa)
                    }
                    
                }
                   
                usleep(520000)
            }
        }
    }
    
    public func loseSound() {
        let sound = "loseSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        DispatchQueue.main.async {
            self.run(playSound)
        }
    }
    
    public func setupBackground() {
        let backgroundSprite = SKSpriteNode()
        backgroundSprite.texture = SKTexture(imageNamed: "bk.jpg")
        backgroundSprite.colorBlendFactor = 1
        backgroundSprite.color = UIColor(hexString: "#E4DED3").withAlphaComponent(0.35)
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
        
        let sound = "backgroundSoung.mp3"
        let node = SKAudioNode(fileNamed: sound)
        self.addChild(node)
        node.run(.play())
        
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
                        style: .page1)
        self.addChild(state1)
        state1.setOutput(text: "I", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state1.holder.lineWidth = 2.0
        states.append(state1)
        
        let state2 = FSMState(
                        side: 50,
                        position: CGPoint(x: -1*spacingX, y: yPos + deltaY),
                        name: "state2",
                        style: .page1)
        self.addChild(state2)
        state2.setOutput(text: "II", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state2.holder.lineWidth = 2.0
        state2.alpha = 0.25
        states.append(state2)
        
        let state3 = FSMState(
                        side: 50,
                        position: CGPoint(x: 1*spacingX, y: yPos + deltaY),
                        name: "state3",
                        style: .page1)
               
        self.addChild(state3)
        state3.setOutput(text: "III", labelPos: CGPoint(x: -32, y: -45), rotate: 0.0, size: 20)
        state3.holder.lineWidth = 2.0
        state3.alpha = 0.25
        states.append(state3)
        
        
        let state4 = FSMState(
                        side: 50,
                        position: CGPoint(x: 3*spacingX, y: yPos + deltaY),
                        name: "state4",
                        style: .page1)
               
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
                        style: .page1)
        self.addChild(line1)
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[1].edgePosition(at: 0.0),
                        to: states[2].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        headSize: 12.0,  name: "line2",
                        style: .page1)
        self.addChild(line2)
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[2].edgePosition(at: 0.0),
                        to: states[3].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        headSize: 12.0,  name: "line3",
                        style: .page1)
        self.addChild(line3)
        lines.append(line3)
        
    }
    
    public func passPhase() {
        guard let nextState = FSMLogic.fsm3(from: currentState) else {
            return
        }
        
        switch nextState {
        case .second:
            // change parameters here
            states[1].gotTouched(view: self.view!) { (_) in }
            states[1].alpha = 1.0
            states[0].alpha = 0.25
        case .third:
            // change parameters here
            states[2].gotTouched(view: self.view!) { (_) in }
            states[2].alpha = 1.0
            states[1].alpha = 0.25
        case .forth:
            states[3].gotTouched(view: self.view!) { (_) in }
            states[3].alpha = 1.0
            states[2].alpha = 0.25
            fireworks()
        default:
            print("SHOULDNT ENTER HERE")
            break
        }
        currentState = nextState
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
        
        let dx = -(ball.position.x - 0.0)
        let dy = -(ball.position.y - 20.0)
        print(dx)
        print(dy)
        
        let moveAction = SKAction.applyForce(CGVector(dx: dx, dy: dy), duration: 0.1)
        let scaleDown = SKAction.scale(by: 0.5, duration: 0.7)
        ball.removeAllActions()
        ball.run(SKAction.group([moveAction, scaleDown])) {[weak self ] in
            self?.ball.removeFromParent()
            DispatchQueue.main.async {
                self?.setupBall()
            }
        }
        dirArrow.removeFromParent()
    }
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
}

extension GameScene3: SKPhysicsContactDelegate {
    
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
            print("A")
            if nameB == "endNode" {
                passPhase()
            }
        } else if nameA == "endNode" {
            print("B")
            passPhase()
        } else if nameA.hasPrefix("hole") {
            print("C")
            
        }
        self.ball.physicsBody = nil
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

