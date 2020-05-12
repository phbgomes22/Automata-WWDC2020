//
//  GameScene2.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 11/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//
import SpriteKit
import UIKit

public class GameScene2: SKScene {
    
    public var states : [FSMState] = []
    public var lines : [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var fsmString: String = "🐶🎱🤖🎱🤖" //🤖🎱🔥🎩🎩🐶
    public var firstState: FSMLogic.StatesPG1 = FSMLogic.StatesPG1.third //FSMLogic.StatesPG1.first
    public var deltaY: CGFloat = -50.0
    public var expectedOutput = "BANANA"
    
    public var wordLabel: FSMOutput = FSMOutput(fontSize: 50)
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
      //  self.setParticles()
        self.setupBoard()
       // self.setWordLabel()
        //self.setSound()
       // self.setupBackground()
    }
    
    public func fireworks() {
        
        let sound = "winSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        DispatchQueue.main.async {
            self.run(playSound)
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
        backgroundSprite.texture = SKTexture(imageNamed: "backgroundPG1")
        backgroundSprite.color = UIColor(hexString: "#DCD6CA")
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
    
    public func setWordLabel() {
        self.addChild(wordLabel)
        
        wordLabel.position = CGPoint(x: 0.0, y: -280.0)
        wordLabel.fontColor = UIColor(hexString: "#333333")
        wordLabel.fontName =  "Futura-Bold"
        wordLabel.color = UIColor(hexString: "#FDFDFD")
        wordLabel.restAnimation()
    }
    
    public func setupBoard() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupStates()
            self.setupLines()
        }
    }
    
    public func setupStates() {
        
        let state1 = FSMState(
                        side: 75,
                        position: CGPoint(x: -40, y: 240 + deltaY),
                        name: "state1",
                        style: .page1)
        self.addChild(state1)
        states.append(state1)
        
        
        let state2 = FSMState(
                        side: 75,
                        position: CGPoint(x: -150, y: 10 + deltaY),
                        name: "state2",
                        style: .page1)
        self.addChild(state2)
        states.append(state2)
        
        let state3 = FSMState(
                        side: 75,
                        position: CGPoint(x: 110, y: -60 + deltaY),
                        name: "state3",
                        style: .page1)
               
        self.addChild(state3)
        states.append(state3)
        
        
        let state4 = FSMState(
                        side: 75,
                        position: CGPoint(x: 180, y: 150 + deltaY),
                        name: "state3",
                        style: .page1)
               
        self.addChild(state4)
        states.append(state4)
    }
    
    public func setupLines() {
        let line1 = FSMLine(
                        from: states[0].edgePosition(at: CGFloat.pi*1),
                        to: states[1].edgePosition(at: CGFloat.pi/1.7, lambdaRadius: 1.4),
                        dx: 2.2,
                        dy: 15.5, name: "line1",
                        style: .page1)
        self.addChild(line1)
        line1.setLabel(at: CGPoint(x: -180.0, y: 150.0 + deltaY), text: "🤖")
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[1].edgePosition(at: CGFloat.pi/5),
                        to: states[0].edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
                        dx: 0.9,
                        dy: 0.1, name: "line2",
                        style: .page1)
        self.addChild(line2)
        line2.setLabel(at: CGPoint(x: -70.0, y: 80.0 + deltaY), text: "🔥")
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[1].edgePosition(at: -CGFloat.pi/2.3),
                        to: states[0].edgePosition(at: CGFloat.pi/4, lambdaRadius: 1.4),
                        dx: 1.2,
                        dy: -0.3, name: "line3",
                        style: .page1)
      //  self.addChild(line3)
        line3.setLabel(at: CGPoint(x: -30.0, y: 40.0 + deltaY), text: "🎱")
        lines.append(line3)
        
        
        let line4 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.9),
                        to: states[1].edgePosition(at: -CGFloat.pi/8, lambdaRadius: 1.4),
                        dx: 0.6,
                        dy: 0.52, name: "line4",
                        style: .page1)
    //    self.addChild(line4)
        line4.setLabel(at: CGPoint(x: 70.0, y: 105.0 + deltaY), text: "🐶")
        lines.append(line4)
        
        
        let line5 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.6),
                        to: states[2].edgePosition(at: CGFloat.pi*0.1, lambdaRadius: 1.4),
                        dx1: 0.9,  dy1: 7.0,
                        dx2: 1.8,  dy2: 4.2,
                        headSize: 15, name: "line5",
                        style: .page1)
      //  self.addChild(line5)
        line5.setLabel(at: CGPoint(x: 225.0, y: 110.0 + deltaY), text: "🎩")
        lines.append(line5)
        
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
       
        
    }
    
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

