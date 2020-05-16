//
//  GameScene2.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 11/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//
import SpriteKit
import UIKit
import GameplayKit
import PlaygroundSupport
import AVFoundation

public class GameScene2: SKScene {
    
    public var backgroundPlayer: AVAudioPlayer!
    public var states : [FSMLogic.StatesPG2 : FSMState] = [:]
    public var lines : [FSMLine] = []
    public var whiteLines: [FSMLine] = []
    public var coloredLines: [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var randomArrays: [Bool] = []
    public var currentState: FSMLogic.StatesPG2 = FSMLogic.StatesPG2.third //FSMLogic.StatesPG1.first
    public var currentMove: Int = 0
    public var isGameLost: Bool = false
    public var backgroundSprite: SKSpriteNode!
    public var shapeNodeLeft: SKShapeNode!
    public var shapeNodeRight: SKShapeNode!
    public var shapeNodeFull: SKShapeNode!
    public var isTouchingEnabled: Bool = false
    
    // THIS WILL CHANGE
    public var numberOfMoves: Int = 1
    
    public var deltaY: CGFloat = -50.0

    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
       // self.setSound()
        self.setupBackground()
        
        if numberOfMoves > 0 {
            self.draftArray(delay: 2)
        }
    }
    
    public func drawDrafter() {
        
        let center = CGPoint(x: 0.0, y:  -250.0)
        let radius: CGFloat = 45.0
        let height: CGFloat = 70.0
        
        
        let fullPad = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: 4*radius, height: height), cornerRadius: 10.0)
        shapeNodeFull = SKShapeNode(path: fullPad.cgPath)
        shapeNodeFull.position = CGPoint(x: center.x - 2*radius, y: center.y - height)
        shapeNodeFull.fillColor = UIColor(hexString: "#1f1f1f")
        shapeNodeFull.lineWidth = 0
        self.addChild(shapeNodeFull)
        
        let leftPad = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: 2*radius, height: height), byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        shapeNodeLeft = SKShapeNode(path: leftPad.cgPath)
        shapeNodeLeft.position = CGPoint(x: center.x - 2*radius, y: center.y - height)
        shapeNodeLeft.fillColor = UIColor(hexString: "#814cC6")
        shapeNodeLeft.lineWidth = 7
        shapeNodeLeft.alpha = 0.3
        shapeNodeLeft.strokeColor = UIColor(hexString: "#814cC6").withAlphaComponent(0.3)
        self.addChild(shapeNodeLeft)
        
        
        let rightPad = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: 2*radius, height: height), byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
     
        shapeNodeRight = SKShapeNode(path: rightPad.cgPath)
        shapeNodeRight.position = CGPoint(x: center.x, y: center.y - height)
        shapeNodeRight.fillColor = UIColor(hexString: "#F8F8F8")
        shapeNodeRight.lineWidth = 7
        shapeNodeRight.alpha = 0.3
        shapeNodeRight.strokeColor = UIColor(hexString: "#E4DED3").withAlphaComponent(0.3)
        self.addChild(shapeNodeRight)
        
    }
    
    public func draftArray(delay: Int) {
        
        drawDrafter()
        
        let alphaHigher = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        let alphaLower = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
        let scaleAction = SKAction.sequence([alphaHigher, .wait(forDuration: 0.8), alphaLower, .wait(forDuration: 0.3)])

        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let playSound = SKAction.playSoundFileNamed(Sound.memorize, waitForCompletion: true)
        
        DispatchQueue.global(qos: .userInteractive).async() {
            sleep(UInt32(delay))
            for _ in 1...self.numberOfMoves {
                let rand = Bool.random()
                self.randomArrays.append(rand)

                let group = DispatchGroup()
                group.enter()
                
                self.run(playSound)
                
                if rand {
                    self.shapeNodeLeft.run(scaleAction) {
                        group.leave()
                    }
                    for line in self.coloredLines {
                        line.animateLabel()
                    }
                } else {
                    self.shapeNodeRight.run(scaleAction) {
                        group.leave()
                    }
                    for line in self.whiteLines {
                        line.animateLabel()
                    }
                }
                
                group.wait()
            }
            
            let array = [("1️⃣", FSMLogic.StatesPG2.first), ("2️⃣", FSMLogic.StatesPG2.second), ("3️⃣", FSMLogic.StatesPG2.third), ("4️⃣", FSMLogic.StatesPG2.forth)]
            let random = Int.random(in: 0...3)
            
            // sets first state
            self.currentState = array[random].1
            
            let state = self.states[self.currentState]
            self.moveCamera(to: state!)
            state?.gotTouched(view: self.view!, completion: { (_) in })
            self.shapeNodeFull.run(fadeOut)
            self.shapeNodeLeft.run(fadeOut)
            self.shapeNodeRight.run(fadeOut)
            
            self.isTouchingEnabled = true
        }
    }
    
    public func fireworks() {
        
        let sound = "winSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        DispatchQueue.main.async {
            self.run(playSound)
            
            PlaygroundPage.current.assessmentStatus = .pass(message: " **Great!** When you're ready, go to the [**Next Page**](@next)!")
        }
        DispatchQueue.global(qos: .userInteractive).async {
            
            var arrayFireworks = [CGPoint(x: -200.0, y: 300.0),
                                  CGPoint(x: 180.0, y: 240.0),
                                  CGPoint(x: 70.0, y: -240.0),
                                  CGPoint(x: -90.0, y: -10.0)]
            
           var arrayColors: [UIColor] = [UIColor(hexString: "#512c96"),
                                         UIColor(hexString: "#3c6f9c"),
                                         UIColor(hexString: "#dd6892"),
                                         UIColor(hexString: "#f9c6ba")]
            
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
    
    public func moveCamera(to state: FSMState) {
        
        let width: CGFloat = 2400
        let height: CGFloat = 2080
        //
        let shapeNodeBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.15), size: CGSize(width: width, height: height))
        //shapeNodeBackground.alpha = 0.0
    
        let mask = SKSpriteNode(color: .white, size: CGSize(width: width, height: height))
        mask.anchorPoint = .zero
        mask.position = CGPoint(x: -width/2, y: -height/2)
        mask.alpha = 0.0
        
        let circle = SKShapeNode(circleOfRadius: 70.0)
        circle.alpha = 0.001
        circle.blendMode = .replace
        circle.fillColor = .white
        
        mask.addChild(circle)
        let statePos = state.position
        circle.position = CGPoint(x: width/2 + statePos.x, y: height/2 + statePos.y)
        
        let cropNode = SKCropNode()
        cropNode.maskNode = mask
        cropNode.addChild(shapeNodeBackground)
        cropNode.position = CGPoint(x: 0, y: 0)
        cropNode.alpha = 1.0
        self.addChild(cropNode)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.6)
        
        mask.run(.sequence([fadeIn, fadeOut])) {
            cropNode.removeAllChildren()
            cropNode.removeFromParent()
        }
        
    }
    
    public func setupBackground() {
        backgroundSprite = SKSpriteNode()
        backgroundSprite.texture = SKTexture(imageNamed: "t.jpg")
        backgroundSprite.color = UIColor(hexString: "#DCD6CA").withAlphaComponent(0.28)
        backgroundSprite.colorBlendFactor = 1
        backgroundSprite.size = CGSize(width: 1400, height: 1180)
        backgroundSprite.position = CGPoint(x: 0.0, y: 0)
        backgroundSprite.zPosition = -100
        backgroundSprite.zRotation = .pi
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
        } catch {
            // couldn't load file :(
        }
    }
    
    
    public func setupBoard() {
        self.setupStates()
        self.setupLines()
    }
    
    public func setupStates() {
        
        let state1 = FSMState(
                        side: 75,
                        position: CGPoint(x: -70, y: 240 + deltaY),
                        name: "state1",
                        style: .page2)
        self.addChild(state1)
        state1.setOutput(text: "I", labelPos: CGPoint(x: -40, y: 50), rotate: -.pi*0.6, size: 25.0)
        states[.first] = state1
        
        
        let state2 = FSMState(
                        side: 75,
                        position: CGPoint(x: -180, y: 10 + deltaY),
                        name: "state2",
                        style: .page2)
        state2.setOutput(text: "II", labelPos: CGPoint(x: -48, y: -68), rotate: 0.0, size: 25.0)
        self.addChild(state2)
        states[.second] = state2
        
        let state3 = FSMState(
                        side: 75,
                        position: CGPoint(x: 110, y: -60 + deltaY),
                        name: "state3",
                        style: .page2)
        
        state3.setOutput(text: "III", labelPos: CGPoint(x: 38, y: -75), rotate: .pi*0.4, size: 25.0)
        self.addChild(state3)
        states[.third] = state3
        
        
        let state4 = FSMState(
                        side: 75,
                        position: CGPoint(x: 180, y: 150 + deltaY),
                        name: "state4",
                        style: .page2)
        
        state4.setOutput(text: "IV", labelPos: CGPoint(x: 62, y: 28), rotate: .pi*0.9, size: 25.0)
        self.addChild(state4)
        states[.forth] = state4
    }
    
    public func setupLines() {
        let line1 = FSMLine(
            from: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*1.1),
            to: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi/1.7, lambdaRadius: 1.4),
            dx: 1.8,
            dy: 12.5, name: "line1Color",
            style: .page2)
        
        self.addChild(line1)
        line1.setColor(at: CGPoint(x: -165.0, y: 150.0 + deltaY), color: UIColor(hexString: "#512c96"))
        lines.append(line1)
        coloredLines.append(line1)
        
        let line2 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi/5),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
            dx: 0.9,
            dy: 0.1, name: "line2",
            style: .page2)
        
        self.addChild(line2)
        line2.setColor(at: CGPoint(x: -125.0, y: 85.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line2)
        whiteLines.append(line2)
        
        let line3 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: -CGFloat.pi/3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*1.1, lambdaRadius: 1.4),
            dx: 0.5,
            dy: 1.2, name: "line3Color",
            style: .page2)
        
        self.addChild(line3)
        line3.setColor(at: CGPoint(x: -60.0, y: -90.0 + deltaY), color: UIColor(hexString: "#512c96"))
        lines.append(line3)
        coloredLines.append(line3)
        
        
        let line4 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.9),
            to: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.50,
            dy: 2.2, name: "line4",
            style: .page2)
        
        self.addChild(line4)
        line4.setColor(at: CGPoint(x: -20.0, y: -36.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line4)
        whiteLines.append(line4)
        
        
        let line5 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.05),
            to: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: -CGFloat.pi*0.35, lambdaRadius: 1.4),
            dx: 1.6,  dy: -1.2,
            name: "line5Color",
            style: .page2)
        
        self.addChild(line5)
        line5.setColor(at: CGPoint(x: 200.0, y: -25.0 + deltaY), color: UIColor(hexString: "#512c96"))
        lines.append(line5)
        coloredLines.append(line5)
        
        
        
        let line6 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*1.2),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.45, lambdaRadius: 1.4),
            dx: 1.0,  dy: -1.0,
            name: "line6",
            style: .page2)
        
        self.addChild(line6)
        line6.setColor(at: CGPoint(x: 140.0, y: 55.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line6)
        whiteLines.append(line6)
        
        
        let line7 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*0.7),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.6,  dy: 1.0,
            name: "line7Color",
            style: .page2)
        
        self.addChild(line7)
        line7.setColor(at: CGPoint(x: 98.0, y: 200.0 + deltaY), color: UIColor(hexString: "#512c96"))
        lines.append(line7)
        coloredLines.append(line7)
        
        
        let line8 = FSMLine(
            from: states[FSMLogic.StatesPG2.first]!.edgePosition(at: -CGFloat.pi*0.3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.65, lambdaRadius: 1.4),
            dx: -0.9,  dy: 0.0,
            name: "line7",
            style: .page2)
        
        self.addChild(line8)
        line8.setColor(at: CGPoint(x: 10.0, y: 95.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
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
        if !isTouchingEnabled {
            return
        }
       
        for node in self.nodes(at: pos) {
            if let state = node as? FSMState {
                
                state.gotTouched(view: self.view!) { (bool) in }
                
                if currentMove == numberOfMoves  {return}
                
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
                
                
                currentState = rm
                // check if the touched state is the right state
                if(nextState?.name != state.name) {
                    isGameLost = true
                    endGame()
                    return
                }
                
                if currentMove == numberOfMoves {
                    self.endGame()
                }
            }
        }
        
    }
    
    public func endGame() {
        currentMove = numberOfMoves
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
}

