//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import UIKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var spinnyNode : SKShapeNode!
    
    override func didMove(to view: SKView) {
        let w = (size.width + size.height) * 0.05
        
        spinnyNode = FSMState(color: .white)
        spinnyNode.lineWidth = 2.5
        
    }
    
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        guard let n = spinnyNode.copy() as? SKShapeNode else { return }
        
        n.position = pos
        addChild(n)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


/// Class State


public class FSMState: SKShapeNode {
    
    public init(color: UIColor = UIColor.white) {
        super.init()
        self.setDraw()
    }
    
    public override init() {
        super.init()
        self.setDraw()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restAnimation() {
        let scale = SKAction.scaleX(by: 1.15, y: 1.12, duration: 2.0)
        self.run(.repeatForever(.sequence([scale, scale.reversed()])))
    }
    
    private func setDraw() {
        
        let side = 50.0
        let path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side))
        
        self.path = path.cgPath
        
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = GameScene(size: UIScreen.main.bounds.size)
    // Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFill
    
    // Present the scene
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
