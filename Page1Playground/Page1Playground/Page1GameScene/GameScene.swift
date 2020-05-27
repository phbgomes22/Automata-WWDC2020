//: A SpriteKit based Playground

import SpriteKit
import UIKit
//import PlaygroundSupport
import GameplayKit


public class GameScene: SKScene {
    
    public var states : [FSMState] = []
    public var lines : [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var fsmString: String = "🐶🎱🤖" //🤖🎱🔥🎩🎩🐶
    public var firstState: FSMLogic.StatesPG1 = FSMLogic.StatesPG1.third //FSMLogic.StatesPG1.first
    public var deltaY: CGFloat = -50.0
    public var expectedOutput = "BANANA"
    public let backgroundSprite = SKSpriteNode()
    
    public var wordLabel: FSMOutput = FSMOutput(fontSize: 50)
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        self.setWordLabel()
        //self.setSound()
        self.setupBackground()
        
    }
    
    public func fireworks() {
        print("AAA")
        let sound = "winSound"
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        self.run(playSound)
        print("BBB")
      //  PlaygroundPage.current.assessmentStatus = .pass(message: " **Great!** When you're ready, go to the [**Next Page**](@next)!")
        
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
        
        self.run(playSound)
        
    }
    
    public func setupBackground() {
        backgroundSprite.texture = SKTexture(imageNamed: "t1.jpg")
        backgroundSprite.color = UIColor(hexString: "#DCD6CA").withAlphaComponent(0.25)
        backgroundSprite.colorBlendFactor = 1
        backgroundSprite.size = CGSize(width: 1400*1.5, height: 980*1.5)
        backgroundSprite.position = CGPoint(x: 0.0, y: -350.0)
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
        self.setupStates()
        self.setupLines()
    }
    
    public func setupStates() {
        
        let state1 = FSMState(
                        side: 80,
                        position: CGPoint(x: -100, y: 0.0),
                        name: "state1",
                        style: .page2)
        self.addChild(state1)
        state1.setOutput(text: "S", labelPos: CGPoint(x: -50, y: -70), rotate: 0.0)
        states.append(state1)
        
        let state2 = FSMState(
                        side: 80,
                        position: CGPoint(x: 100, y: 0.0),
                        name: "state2",
                        style: .page2)
        self.addChild(state2)
        state2.setOutput(text: "M", labelPos: CGPoint(x: 60, y: -60), rotate: .pi/2)
        states.append(state2)

    }
    
    public func setupLines() {
        let line1 = FSMLine(
                        from: states[0].edgePosition(at: 0.0),
                        to: states[1].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        name: "line1",
                        style: .page2)
        self.addChild(line1)
       // line1.setLabel(at: CGPoint(x: -10.0, y: 20.0), text: "🤖")
        lines.append(line1)
        
        
        let line2 = FSMLine(
            from: states[1].edgePosition(at: -CGFloat.pi*0.7),
            to: states[0].edgePosition(at: -CGFloat.pi*0.3, lambdaRadius: 1.4),
                        dx: 0.0, dy: 3.0,
                        name: "line2",
                        style: .page2)
        self.addChild(line2)
        //line2.setLabel(at: CGPoint(x: -10.0, y: 20.0), text: "🤖")
        lines.append(line2)
        
        
        let cameraACtion = SKAction.scale(by: 0.8, duration: 0.3)
        self.scene!.camera!.run(cameraACtion)
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
    
    func startFSM() {
        self.automateFSM() { (ended) in
          //  self.backgroundSprite.alpha = 1.0
            if(!ended) {
                self.wordLabel.update(text: " 🙊?")
                self.loseSound()
            }
            else if (self.wordLabel.text != self.expectedOutput) {
                self.wordLabel.update(text: " 🙊?")
                self.loseSound()
            } else {
                self.wordLabel.update(text: " 🐵!")
                print("OK!")
                self.fireworks()
                
            }
        }
    }
    
    public func touchDown(atPoint pos : CGPoint) {
       
        if isFirstTap {
            
            isFirstTap = false
        }
        
    }
    
    
    public func automateFSM(completion: @escaping (_ ended: Bool) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async() {
            var bool = true
            
            var currentState = self.firstState
            let stringToRun = self.fsmString + "X" // "X" marks the final state!
            for char in stringToRun {
                let nState = FSMLogic.fsm1(from: currentState, text: String(char))
                print(char)

                var currStateNode: FSMState!
                var nLineNode: FSMLine?
                
                switch currentState {
                case .first:
                    currStateNode = self.states[0]
                    if nState == .first { // if im going from current state to nState !!!! #Attention!
                        nLineNode = nil
                    } else if nState == .second {
                        nLineNode = self.lines[0]
                    } else if nState == .third {
                       nLineNode = self.lines[1]
                    }
                case .second:
                    currStateNode = self.states[1]
                    if nState == .first { // if im going from current state to nState !!!! #Attention!
                        nLineNode = self.lines[2]
                    } else if nState == .second {
                        nLineNode = nil
                    } else if nState == .third {
                        nLineNode = nil
                    }
                case .third:
                    currStateNode = self.states[2]
                    if nState == .first { // if im going from current state to nState !!!! #Attention!
                        nLineNode = nil
                    } else if nState == .second {
                        nLineNode = self.lines[3]
                    } else if nState == .third {
                        nLineNode = self.lines[4]
                    }
                }
                
                
                print("OK1!")
                let output = currStateNode.getOutput()
                self.wordLabel.update(text: output)
                print("OK2!")
                if let lNode = nLineNode {
                    currStateNode.gotTouched(view: self.view!) { bool in
                        if(bool) {
                            lNode.gotUsed(scene: self) {
                            }
                        }
                    }
                    sleep(2)
                } else {
                    print("ELSE")
                    currStateNode.gotTouched(view: self.view!) { _ in
                        print(completion)
                        completion(bool)
                    }
                    return
                }
                
                print("Fim wait")
                
                // sets next state
                guard let nextState = nState else { // if there is no next state, the line wont animate
                    if(char != "X") {
                        bool = false
                    }
                    break
                }
                currentState = nextState
                print("Proximo")
            }
            
            completion(bool)
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
        
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
