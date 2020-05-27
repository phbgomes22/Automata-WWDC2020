
import SpriteKit
import UIKit
import GameplayKit
import PlaygroundSupport
import AVFoundation

public class LiveView2: SKScene {
    
    public var states : [FSMLogic.StatesPG2 : FSMState] = [:]
    public var lines : [FSMLine] = []
    public var whiteLines: [FSMLine] = []
    public var coloredLines: [FSMLine] = []
    
    public var isFirstTap: Bool = true
    public var randomArrays: [Bool] = []
    public var currentState: FSMLogic.StatesPG2 = FSMLogic.StatesPG2.third
    public var currentMove: Int = 0
    public var isGameLost: Bool = false
    public var backgroundSprite = SKSpriteNode()
    public var shapeNodeLeft = SKShapeNode()
    public var shapeNodeRight = SKShapeNode()
    public var backgroundPlayer: AVAudioPlayer!
    
    // THIS WILL CHANGE
    public var numberOfMoves: Int = 1
    
    public var deltaY: CGFloat = -50.0

    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setParticles()
        self.setupBoard()
        self.setSound()
        self.setupBackground()
        
       
    }
    
    public func setupBackground() {

        let image = UIImage(named: "t.jpg")!.noir!
        backgroundSprite.texture = SKTexture(image: image)
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
            backgroundPlayer.numberOfLoops = -1
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
            style: .normal)
        self.addChild(state1)
        state1.setOutput(text: "I", labelPos: CGPoint(x: -40, y: 50), rotate: -.pi*0.6, size: 25.0)
        states[.first] = state1
        
        
        let state2 = FSMState(
            side: 75,
            position: CGPoint(x: -180, y: 10 + deltaY),
            name: "state2",
            style: .normal)
        state2.setOutput(text: "II", labelPos: CGPoint(x: -48, y: -68), rotate: 0.0, size: 25.0)
        self.addChild(state2)
        states[.second] = state2
        
        let state3 = FSMState(
            side: 75,
            position: CGPoint(x: 110, y: -60 + deltaY),
            name: "state3",
            style: .normal)
        
        state3.setOutput(text: "III", labelPos: CGPoint(x: 38, y: -75), rotate: .pi*0.4, size: 25.0)
        self.addChild(state3)
        states[.third] = state3
        
        
        let state4 = FSMState(
            side: 75,
            position: CGPoint(x: 180, y: 150 + deltaY),
            name: "state4",
            style: .normal)
        
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
            style: .normal)
        
        self.addChild(line1)
        line1.setColor(at: CGPoint(x: -165.0, y: 150.0 + deltaY), color: UIColor(hexString: "#555555"))
        lines.append(line1)
        coloredLines.append(line1)
        
        let line2 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi/5),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
            dx: 0.9,
            dy: 0.1, name: "line2",
            style: .normal)
        
        self.addChild(line2)
        line2.setColor(at: CGPoint(x: -125.0, y: 85.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line2)
        whiteLines.append(line2)
        
        let line3 = FSMLine(
            from: states[FSMLogic.StatesPG2.second]!.edgePosition(at: -CGFloat.pi/3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*1.1, lambdaRadius: 1.4),
            dx: 0.5,
            dy: 1.2, name: "line3Color",
            style: .normal)
        
        self.addChild(line3)
        line3.setColor(at: CGPoint(x: -60.0, y: -90.0 + deltaY), color: UIColor(hexString: "#555555"))
        lines.append(line3)
        coloredLines.append(line3)
        
        
        let line4 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.9),
            to: states[FSMLogic.StatesPG2.second]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.50,
            dy: 2.2, name: "line4",
            style: .normal)
        
        self.addChild(line4)
        line4.setColor(at: CGPoint(x: -20.0, y: -36.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line4)
        whiteLines.append(line4)
        
        
        let line5 = FSMLine(
            from: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.05),
            to: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: -CGFloat.pi*0.35, lambdaRadius: 1.4),
            dx: 1.6,  dy: -1.2,
            name: "line5Color",
            style: .normal)
        
        self.addChild(line5)
        line5.setColor(at: CGPoint(x: 200.0, y: -25.0 + deltaY), color: UIColor(hexString: "#555555"))
        lines.append(line5)
        coloredLines.append(line5)
        
        
        
        let line6 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*1.2),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.45, lambdaRadius: 1.4),
            dx: 1.0,  dy: -1.0,
            name: "line6",
            style: .normal)
        
        self.addChild(line6)
        line6.setColor(at: CGPoint(x: 140.0, y: 55.0 + deltaY), color: UIColor(hexString: "#F2F2F2"))
        lines.append(line6)
        whiteLines.append(line6)
        
        
        let line7 = FSMLine(
            from: states[FSMLogic.StatesPG2.forth]!.edgePosition(at: CGFloat.pi*0.7),
            to: states[FSMLogic.StatesPG2.first]!.edgePosition(at: CGFloat.pi*0.0, lambdaRadius: 1.4),
            dx: 0.6,  dy: 1.0,
            name: "line7Color",
            style: .normal)
        
        self.addChild(line7)
        line7.setColor(at: CGPoint(x: 98.0, y: 200.0 + deltaY), color: UIColor(hexString: "#555555"))
        lines.append(line7)
        coloredLines.append(line7)
        
        
        let line8 = FSMLine(
            from: states[FSMLogic.StatesPG2.first]!.edgePosition(at: -CGFloat.pi*0.3),
            to: states[FSMLogic.StatesPG2.third]!.edgePosition(at: CGFloat.pi*0.65, lambdaRadius: 1.4),
            dx: -0.9,  dy: 0.0,
            name: "line7",
            style: .normal)
        
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
    
}


public class LiveView2Controller: LiveViewController {

    var gameScene2: GameScene2!
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
        if let scene = GameScene2(fileNamed: "GameScene2") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            self.gameScene2 = scene
            // Present the scene
            sceneView.presentScene(scene)
        }
        self.view = sceneView
    }

    
    public override func receive(_ message: PlaygroundValue) {
        
        var flags = 0
        if case let PlaygroundValue.integer(moves) = message {
            self.gameScene2.numberOfMoves = moves
            flags += 1
        }
        
        if flags == 1 {
            self.gameScene2.draftArray()
        }
        
    }
}
