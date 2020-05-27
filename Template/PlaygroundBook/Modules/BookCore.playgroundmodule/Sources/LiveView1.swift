//
//  LiveView1.swift
//  BookCore
//
//  Created by Pedro Gomes on 11/05/20.
//
#warning("DONT REMOVE LIVEVIEWCONTROLLER")
import SpriteKit
import UIKit
import GameplayKit
import PlaygroundSupport
import AVFoundation


public class LiveView1: SKScene {
    
    private var states : [FSMState] = []
    private var lines : [FSMLine] = []
    public var backgroundPlayer: AVAudioPlayer!
    
    private var isFirstTap: Bool = true
    private var deltaY: CGFloat = -50.0
    
    private var wordLabel: FSMOutput = FSMOutput(fontSize: 50)
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#DDDDDD")
        self.setParticles()
        self.setupBoard()
        self.setupBackground()
        self.setSound()
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
   
    private func setupBackground() {
        let backgroundSprite = SKSpriteNode()
        
        let image = UIImage(named: "t1.jpg")!.noir!
        backgroundSprite.texture = SKTexture(image: image)
        backgroundSprite.color = UIColor(hexString: "#CCCCCC").withAlphaComponent(0.25)
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
    
    private func setupBoard() {
        self.setupStates()
        self.setupLines()
    }
    
    private func setupStates() {
        
        let state1 = FSMState(
                        side: 75,
                        position: CGPoint(x: -160, y: -50 + deltaY),
                        name: "state1",
                        style: .normal)
        self.addChild(state1)
        state1.setOutput(text: "N", labelPos: CGPoint(x: -48, y: -68), rotate: 0.0)
        states.append(state1)
        
        let state2 = FSMState(
                        side: 75,
                        position: CGPoint(x: -40, y: 210 + deltaY),
                        name: "state2",
                        style: .normal)
        self.addChild(state2)
        state2.setOutput(text: "A", labelPos: CGPoint(x: 46, y: 46), rotate: .pi)
        states.append(state2)
        
        let state3 = FSMState(
                        side: 75,
                        position: CGPoint(x: 160, y: 50 + deltaY),
                        name: "state3",
                        style: .normal)
               
        self.addChild(state3)
        state3.setOutput(text: "B", labelPos: CGPoint(x: 26, y: -82), rotate: .pi/3)
        states.append(state3)
    }
    
    private func setupLines() {
        let line1 = FSMLine(
                        from: states[0].edgePosition(at: CGFloat.pi/1.3),
                        to: states[1].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        dx: 1.2,
                        dy: 0.5, name: "line1",
                        style: .normal)
        self.addChild(line1)
        line1.setLabel(at: CGPoint(x: -210.0, y: 90.0 + deltaY), text: "🤖")
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[0].edgePosition(at: -CGFloat.pi/8),
                        to: states[2].edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
                        dx: -0.3,
                        dy: 2.5, name: "line2",
                        style: .normal)
        self.addChild(line2)
        line2.setLabel(at: CGPoint(x: 35.0, y: -80.0 + deltaY), text: "🔥")
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[1].edgePosition(at: -CGFloat.pi/2.3),
                        to: states[0].edgePosition(at: CGFloat.pi/4, lambdaRadius: 1.4),
                        dx: 1.2,
                        dy: -0.3, name: "line3",
                        style: .normal)
        self.addChild(line3)
        line3.setLabel(at: CGPoint(x: -35.0, y: 45.0 + deltaY), text: "🎱")
        lines.append(line3)
        
        
        let line4 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.9),
                        to: states[1].edgePosition(at: -CGFloat.pi/8, lambdaRadius: 1.4),
                        dx: 0.6,
                        dy: 0.52, name: "line4",
                        style: .normal)
        self.addChild(line4)
        line4.setLabel(at: CGPoint(x: 100.0, y: 125.0 + deltaY), text: "🐶")
        lines.append(line4)
        
        
        let line5 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.6),
                        to: states[2].edgePosition(at: CGFloat.pi*0.1, lambdaRadius: 1.4),
                        dx1: 0.9,  dy1: 7.0,
                        dx2: 1.8,  dy2: 4.2,
                        headSize: 15, name: "line5",
                        style: .normal)
        self.addChild(line5)
        line5.setLabel(at: CGPoint(x: 225.0, y: 130.0 + deltaY), text: "🎩")
        
        lines.append(line5)
        
    }
    
    private func setParticles() {
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




public class LiveView1Controller: LiveViewController {
    
    var gameScene: GameScene!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
        if let scene = GameScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            sceneView.presentScene(scene)

            self.gameScene = scene
        }

        self.view = sceneView
    }
    
    public override func receive(_ message: PlaygroundValue) {
        
        var flags = 0
        if case let PlaygroundValue.array(array) = message {
            if case let PlaygroundValue.string(answer) = array[0] {
                self.gameScene.fsmString = answer
                flags += 1
            }
            if case let PlaygroundValue.string(chosenState) = array[1] {
                flags += 1
                if chosenState == "A" {
                    self.gameScene.firstState = FSMLogic.StatesPG1.second
                } else if chosenState == "B" {
                    self.gameScene.firstState = FSMLogic.StatesPG1.third
                } else if chosenState == "N" {
                   self.gameScene.firstState = FSMLogic.StatesPG1.first
                }
            }
        }
        
        if flags == 2 {
            self.gameScene.startFSM()
        }

    }

}
