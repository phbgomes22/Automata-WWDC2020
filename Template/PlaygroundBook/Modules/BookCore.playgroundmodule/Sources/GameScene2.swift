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
    
    public var states : [FSMLogic.StatesPG2 : FSMState] = [:]
    public var lines : [FSMLine] = []
    public var whiteLines: [FSMLine] = []
    public var coloredLines: [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var randomArrays: [Bool] = []
    public var currentState: FSMLogic.StatesPG2 = FSMLogic.StatesPG2.third //FSMLogic.StatesPG1.first
    public var currentMove: Int = 0
    public var isGameLost: Bool = false
    public var backgroundSprite = SKSpriteNode()
    
    // THIS WILL CHANGE
    public var numberOfMoves: Int = 3
    
    
    public var deltaY: CGFloat = -50.0
    
    public var instructionNode = SKSpriteNode()

    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        //self.setSound()
        self.setupBackground()
        
        self.draftArray(delay: 2)
    }
    
    public func draftArray(delay: Int) {
        
        let radius: CGFloat = 40.0
        instructionNode = SKSpriteNode(color: .clear, size: CGSize(width: radius + 10, height: radius + 10))
        let shapeNode2 = SKShapeNode(circleOfRadius: radius)
        shapeNode2.lineWidth = 5.0
        shapeNode2.fillColor = .clear
        shapeNode2.zPosition = 1
        shapeNode2.strokeColor = UIColor(hexString: "#511845").withAlphaComponent(0.15)
        instructionNode.addChild(shapeNode2)
        
        // crop to make a circle
        let shapeNode = SKShapeNode(circleOfRadius: radius + 1)
        let cropNode = SKCropNode()
        cropNode.maskNode = shapeNode
        cropNode.addChild(instructionNode)
        
        
        cropNode.position = CGPoint(x: 0.0, y:  -250.0 )
        shapeNode.fillColor = .white
        self.addChild(cropNode)
        
        cropNode.alpha = 0.0
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        
        let scale = SKAction.scale(by: 0.9, duration: 0.5)
        let seqScale = SKAction.sequence([scale, scale.reversed()])
        
        let groupAction = SKAction.sequence([fadeIn, seqScale, .wait(forDuration: 0.1) , fadeOut])

        
        DispatchQueue.global(qos: .userInteractive).async() {
            sleep(UInt32(delay))
            for _ in 1...self.numberOfMoves {
                let rand = Bool.random()
                self.randomArrays.append(rand)

                let group = DispatchGroup()
                group.enter()
                
                DispatchQueue.main.async() {
                    let playSound = SKAction.playSoundFileNamed(Sound.memorize, waitForCompletion: true)
                    self.run(playSound) {
                        group.leave()
                    }
//                    cropNode.run(groupAction) {
//
//                    }
                    shapeNode2.fillColor = rand ? UIColor(hexString: "#511845") : UIColor(hexString: "#F8F8F8")
                    self.backgroundSprite.color = shapeNode2.fillColor
                    
//                    if rand {
//                        for line in self.coloredLines {
//                            line.animateLabel()
//                        }
//                    } else {
//                        for line in self.whiteLines {
//                            line.animateLabel()
//                        }
//                    }
                }
                
                group.wait()
            }
            
            let array = [("1️⃣", FSMLogic.StatesPG2.first), ("2️⃣", FSMLogic.StatesPG2.second), ("3️⃣", FSMLogic.StatesPG2.third), ("4️⃣", FSMLogic.StatesPG2.forth)]
            let random = Int.random(in: 0...3)
            
            

            let scale = SKAction.scale(by: 0.9, duration: 0.5)
            let action2 = SKAction.sequence([fadeIn, scale, scale.reversed(), .wait(forDuration: 0.8) , fadeOut])
            
            // sets first state
            self.currentState = array[random].1
            
            let spriteImage = emojiToImage(text: array[random].0, size: radius*2.0)
            self.instructionNode.texture = SKTexture(image: spriteImage)
            DispatchQueue.main.async {
                shapeNode2.fillColor = UIColor(hexString: "#F8F8F8")
                shapeNode2.zPosition = -1
                let playSound = SKAction.playSoundFileNamed(Sound.lastMemorize, waitForCompletion: true)
                self.run(playSound)
                cropNode.run(action2)
                self.backgroundSprite.color = UIColor(hexString: "#DCD6CA")
            }
           
        }
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
    
    public func setupBoard() {
        DispatchQueue.main.async() {
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
        state1.setOutput(text: "1", labelPos: CGPoint.zero, rotate: 0.0)
        states[.first] = state1
        
        
        let state2 = FSMState(
                        side: 75,
                        position: CGPoint(x: -180, y: 10 + deltaY),
                        name: "state2",
                        style: .page1)
        self.addChild(state2)
        states[.second] = state2
        
        let state3 = FSMState(
                        side: 75,
                        position: CGPoint(x: 110, y: -60 + deltaY),
                        name: "state3",
                        style: .page1)
               
        self.addChild(state3)
        states[.third] = state3
        
        
        let state4 = FSMState(
                        side: 75,
                        position: CGPoint(x: 180, y: 150 + deltaY),
                        name: "state4",
                        style: .page1)
               
        self.addChild(state4)
        states[.forth] = state4
    }
    
    public func setupLines() {
        let line1 = FSMLine(
            from: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*1.1),
            to: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi/1.7, lambdaRadius: 1.4),
            dx: 1.8,
            dy: 12.5, name: "line1Color",
            style: .page1)
        
        self.addChild(line1)
        line1.setColor(at: CGPoint(x: -165.0, y: 150.0 + deltaY), color: UIColor(hexString: "#511845"))
        lines.append(line1)
        coloredLines.append(line1)
        
        let line2 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi/5),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
            dx: 0.9,
            dy: 0.1, name: "line2",
            style: .page1)
        
        self.addChild(line2)
        line2.setColor(at: CGPoint(x: -125.0, y: 85.0 + deltaY), color: UIColor(hexString: "#DDDDDD"))
        lines.append(line2)
        whiteLines.append(line2)
        
        let line3 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: -CGFloat.pi/3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*1.1, lambdaRadius: 1.4),
            dx: 0.5,
            dy: 1.2, name: "line3Color",
            style: .page1)
        
        self.addChild(line3)
        line3.setColor(at: CGPoint(x: -60.0, y: -90.0 + deltaY), color: UIColor(hexString: "#511845"))
        lines.append(line3)
        coloredLines.append(line3)
        
        
        let line4 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.9),
            to: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.50,
            dy: 2.2, name: "line4",
            style: .page1)
        
        self.addChild(line4)
        line4.setColor(at: CGPoint(x: -20.0, y: -36.0 + deltaY), color: UIColor(hexString: "#DDDDDD"))
        lines.append(line4)
        whiteLines.append(line4)
        
        
        let line5 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.05),
            to: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: -CGFloat.pi*0.35, lambdaRadius: 1.4),
            dx: 1.6,  dy: -1.2,
            name: "line5Color",
            style: .page1)
        
        self.addChild(line5)
        line5.setColor(at: CGPoint(x: 200.0, y: -25.0 + deltaY), color: UIColor(hexString: "#511845"))
        lines.append(line5)
        coloredLines.append(line5)
        
        
        
        let line6 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*1.2),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.45, lambdaRadius: 1.4),
            dx: 1.0,  dy: -1.0,
            name: "line6",
            style: .page1)
        
        self.addChild(line6)
        line6.setColor(at: CGPoint(x: 140.0, y: 55.0 + deltaY), color: UIColor(hexString: "#DDDDDD"))
        lines.append(line6)
        whiteLines.append(line6)
        
        
        let line7 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*0.7),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.6,  dy: 1.0,
            name: "line7Color",
            style: .page1)
        
        self.addChild(line7)
        line7.setColor(at: CGPoint(x: 98.0, y: 200.0 + deltaY), color: UIColor(hexString: "#511845"))
        lines.append(line7)
        coloredLines.append(line7)
        
        
        
        let line8 = FSMLine(
            from: states[FSMLogic.StatesPG2.first]!.edgePosition(at: -CGFloat.pi*0.3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.65, lambdaRadius: 1.4),
            dx: -0.9,  dy: 0.0,
            name: "line7",
            style: .page1)
        
        self.addChild(line8)
        line8.setColor(at: CGPoint(x: 10.0, y: 95.0 + deltaY), color: UIColor(hexString: "#DDDDDD"))
        lines.append(line8)
        whiteLines.append(line8)
        
        
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
                state.gotTouched(view: self.view!) { (bool) in }
                
                if currentMove == numberOfMoves {return}
                
                var nextState: FSMState?
                var rightMove: FSMLogic.StatesPG2?
                if isFirstTap {
                    rightMove = currentState
                    isFirstTap = false
                }
                else {
                    // checks the state that should be touched
                    rightMove = FSMLogic.fsm2(from: self.currentState, bool: self.randomArrays[currentMove])
                    currentMove += 1
                }
                
                guard let rm = rightMove else {
                    isGameLost = true
                    endGame()
                    print("SHOULD NOT ENTER HERE PAGE2")
                    return
                }
                nextState = states[rm]!
                print(rm)
                // check if the touched state is the right state
                if(nextState?.name != state.name) {
                    endGame()
                    isGameLost = true
                    return
                }
                
                currentState = rm
                
                if currentMove == numberOfMoves {
                    self.endGame()
                }
            }
        }
        
    }
    
    public func endGame() {
        currentMove == numberOfMoves
        if !isGameLost {
            fireworks()
        } else {
            loseSound()
            let rightLastState = states[currentState]!
            rightLastState.gotTouched(view: self.view!, completion: { (bool) in  })
            
            for state in states {
                if state.value.name != rightLastState.name {
                    state.value.alpha = 0.2
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





