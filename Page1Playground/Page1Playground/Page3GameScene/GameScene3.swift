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
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        //self.setSound()
        self.setupBackground()
        
        self.ballBase()
        self.setupBall()
        self.setHoles() 
    }
    
    public func setupBall() {
        
        // arrow direction
        
        dirArrow = FSMLine(
            from: CGPoint(x: 0.0, y: 0),
            to: CGPoint(x: 0.0, y: 80.0),
            headSize: 10.0,  name: "lineDir",
            style: .page1)
        dirArrow.body.strokeColor = UIColor.red.withAlphaComponent(0.03)
        dirArrow.body.fillColor = UIColor.red.withAlphaComponent(0.20)
        dirArrow.position = CGPoint(x: 0.0, y: -220.0)
        self.addChild(dirArrow)
        
        
        let durationMove: Double = 1.2
        let moveAction = SKAction.moveTo(x: -80.0, duration: durationMove)
        let moveActionLeft = SKAction.moveTo(x: 80.0, duration: 2*durationMove)
        let moveActionZero = SKAction.moveTo(x: 0.0, duration: durationMove)
        
        let rotate = SKAction.rotate(toAngle: -.pi/9, duration: durationMove)
        let rotateBack = SKAction.rotate(toAngle: .pi/9, duration: 2*durationMove)
        let rotateZero = SKAction.rotate(toAngle: 0.0, duration: durationMove)
        
        let sequenceRotating = SKAction.sequence([rotate, rotateBack, rotateZero])
        let sequenceMoving = SKAction.sequence([moveAction, moveActionLeft, moveActionZero])
        dirArrow.anchorPoint = CGPoint(x: 0.5, y: 2.0)
        dirArrow.run(.repeatForever(.group([sequenceMoving, sequenceRotating])))
        
        
        // ball
        
        let radius: CGFloat = 14.0
        ball = SKShapeNode(circleOfRadius: radius)
        ball.position = CGPoint(x: 0.0, y:  -220.0)
        ball.fillColor = UIColor.orange
        ball.strokeColor = UIColor.clear
        let scaleBall = SKAction.scale(by: 1.1, duration: 0.6)
        let repeatForever = SKAction.repeatForever(.sequence([scaleBall, scaleBall.reversed()]))
        
        self.addChild(ball)
        ball.run(repeatForever)
        
        ball.run(SKAction.repeatForever(sequenceMoving), withKey: "horizontalMove")
        
    }
    
    public func setHoles() {
        let holeNode1 = FSMState(
                            side: 40,
                            position: CGPoint.zero,
                            name: "holeNode1",
                            style: .page3)
        holeNode1.zPosition = -3
        holeNode1.position = CGPoint(x: -70, y: -50 + deltaY)
        self.addChild(holeNode1)
        
        let holeNode2 = FSMState(
                            side: 50,
                            position: CGPoint.zero,
                            name: "holeNode2",
                            style: .page3)
        holeNode2.zPosition = -3
        holeNode2.position = CGPoint(x: 120, y: 110 + deltaY)
        self.addChild(holeNode2)
        
        
        let holeNode3 = FSMState(
                            side: 80,
                            position: CGPoint.zero,
                            name: "holeNode2",
                            style: .page3)
        holeNode3.zPosition = -4
        holeNode3.position = CGPoint(x: -80.0, y: 60.0 + deltaY)
        self.addChild(holeNode3)
        
        holeNode1.rotate(center: CGPoint(x: 80.0 , y: 40.0))
        holeNode2.rotate(center: CGPoint(x: -30.0, y: -20.0))
    }
    
    public func ballBase() {
        let width: CGFloat = 200.0
        let shapeNode = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: width, height: 40.0), cornerRadius: 20.0)
        shapeNode.fillColor = UIColor.white.withAlphaComponent(0.3)
        shapeNode.position = CGPoint(x: -width/2.0, y: -220 - 20)
        self.addChild(shapeNode)
        
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
        
        let endPoint = CGPoint(x: 0, y: 180)
      
        
        let moveAction = SKAction.move(to: endPoint, duration: 0.7)
        let scaleDown = SKAction.scale(by: 0.5, duration: 0.7)
        ball.removeAllActions()
        ball.run(SKAction.group([moveAction, scaleDown])) {[weak self ] in
            self?.ball.removeFromParent()
            DispatchQueue.main.async {
                self?.setupBall()
                self?.passPhase()
                
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

