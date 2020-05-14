//
//  GameScene3.swift
//  BookCore
//
//  Created by Pedro Gomes on 14/05/20.
//

//: A SpriteKit based Playground

import SpriteKit
import UIKit
import PlaygroundSupport
import GameplayKit


public class GameScene3: SKScene {
    
    public var states : [FSMState] = []
    public var lines : [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var currentState: FSMLogic.StatesPG3 = FSMLogic.StatesPG3.first
    public var deltaY: CGFloat = -50.0
    
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        //self.setSound()
        self.setupBackground()
        self.teste()
    }
    
    public func teste() {
        let shapeNode = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 80.0), cornerRadius: 20.0)
        shapeNode.fillColor = UIColor.white
        shapeNode.position = CGPoint(x: -200.0, y: -220 - 40)
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
        backgroundSprite.texture = SKTexture(imageNamed: "t1.jpg")
        backgroundSprite.alpha = 0.25
        backgroundSprite.colorBlendFactor = 1
        backgroundSprite.size = CGSize(width: 1400*1.5, height: 980*1.5)
        backgroundSprite.position = CGPoint(x: 0.0, y: -100.0)
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
        self.setupPads()
    }
    
    public func setupPads() {
        
    }
    
    public func setupTopStates() {
        
        let spacingX: CGFloat = 50.0
        
        let state1 = FSMState(
                        side: 55,
                        position: CGPoint(x: -3*spacingX, y: 220 + deltaY),
                        name: "state1",
                        style: .page1)
        self.addChild(state1)
        state1.setOutput(text: "I", labelPos: CGPoint(x: -35, y: -48), rotate: 0.0, size: 20)
        states.append(state1)
        
        let state2 = FSMState(
                        side: 55,
                        position: CGPoint(x: -1*spacingX, y: 220 + deltaY),
                        name: "state2",
                        style: .page1)
        self.addChild(state2)
        state2.setOutput(text: "II", labelPos: CGPoint(x: -35, y: -48), rotate: 0.0, size: 20)
        states.append(state2)
        
        let state3 = FSMState(
                        side: 55,
                        position: CGPoint(x: 1*spacingX, y: 220 + deltaY),
                        name: "state3",
                        style: .page1)
               
        self.addChild(state3)
        state3.setOutput(text: "III", labelPos: CGPoint(x: -35, y: -48), rotate: 0.0, size: 20)
        states.append(state3)
        
        
        let state4 = FSMState(
                        side: 55,
                        position: CGPoint(x: 3*spacingX, y: 220 + deltaY),
                        name: "state4",
                        style: .page1)
               
        self.addChild(state4)
        state4.setOutput(text: "🏆", labelPos: CGPoint(x: -35, y: -48), rotate: 0.0, size: 20)
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
        case .third:
            // change parameters here
            states[2].gotTouched(view: self.view!) { (_) in }
        case .forth:
            states[3].gotTouched(view: self.view!) { (_) in }
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
    }
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

