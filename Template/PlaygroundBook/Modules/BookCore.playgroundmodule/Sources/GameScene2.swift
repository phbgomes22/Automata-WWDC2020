//
//  GameScene2.swift
//  BookCore
//
//  Created by Pedro Gomes on 12/05/20.
//

import SpriteKit
import GameplayKit
import UIKit
import PlaygroundSupport


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
                        position: CGPoint(x: -70, y: 240 + deltaY),
                        name: "state1",
                        style: .page1)
        self.addChild(state1)
        states.append(state1)
        
        
        let state2 = FSMState(
                        side: 75,
                        position: CGPoint(x: -180, y: 10 + deltaY),
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
        line1.setLabel(at: CGPoint(x: -200.0, y: 150.0 + deltaY), text: "🤖")
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[1].edgePosition(at: CGFloat.pi/5),
                        to: states[0].edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
                        dx: 0.9,
                        dy: 0.1, name: "line2",
                        style: .page1)
        self.addChild(line2)
        line2.setLabel(at: CGPoint(x: -125.0, y: 85.0 + deltaY), text: "🔥")
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[1].edgePosition(at: -CGFloat.pi/3),
                        to: states[2].edgePosition(at: CGFloat.pi*1.0, lambdaRadius: 1.4),
                        dx: 0.5,
                        dy: 1.2, name: "line3",
                        style: .page1)
        self.addChild(line3)
        line3.setLabel(at: CGPoint(x: -60.0, y: -70.0 + deltaY), text: "🎱")
        lines.append(line3)
        
        
        let line4 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.7),
                        to: states[0].edgePosition(at: -CGFloat.pi/3, lambdaRadius: 1.4),
                        dx: 0.18,
                        dy: 0.52, name: "line4",
                        style: .page1)
        self.addChild(line4)
        line4.setLabel(at: CGPoint(x: 36.0, y: 70.0 + deltaY), text: "🐶")
        lines.append(line4)
        
        
        let line5 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.05),
                        to: states[3].edgePosition(at: -CGFloat.pi*0.35, lambdaRadius: 1.4),
                        dx: 1.6,  dy: -1.2,
                        name: "line5",
                        style: .page1)
        self.addChild(line5)
        line5.setLabel(at: CGPoint(x: 195.0, y: -25.0 + deltaY), text: "🎩")
        lines.append(line5)
        
        
        
        let line6 = FSMLine(
                        from: states[3].edgePosition(at: CGFloat.pi*1.2),
                        to: states[2].edgePosition(at: CGFloat.pi*0.45, lambdaRadius: 1.4),
                        dx: 1.0,  dy: -1.0,
                        name: "line6",
                        style: .page1)
        self.addChild(line6)
        line6.setLabel(at: CGPoint(x: 135.0, y: 55.0 + deltaY), text: "🎃")
        lines.append(line6)
        
        
        let line7 = FSMLine(
                        from: states[3].edgePosition(at: CGFloat.pi*0.6),
                        to: states[0].edgePosition(at: CGFloat.pi*0.2, lambdaRadius: 1.4),
                        dx: 0.6,  dy: 1.2,
                        name: "line7",
                        style: .page1)
        self.addChild(line7)
        line7.setLabel(at: CGPoint(x: 98.0, y: 255.0 + deltaY), text: "🧠")
        lines.append(line7)
        
        
        
        let line8 = FSMLine(
                        from: states[0].edgePosition(at: CGFloat.pi*0.0),
                        to: states[3].edgePosition(at: CGFloat.pi*0.9, lambdaRadius: 1.4),
                        dx: 0.6,  dy: 1.5,
                        name: "line7",
                        style: .page1)
        self.addChild(line8)
        line8.setLabel(at: CGPoint(x: 40.0, y: 194.0 + deltaY), text: "🎾")
        lines.append(line8)
        
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
       
        for node in self.nodes(at: pos) {
            if let state = node as? FSMState {
                state.gotTouched(view: self.view!) { (bool) in
                    print(bool)
                }
            }
        }
        
    }
    
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


