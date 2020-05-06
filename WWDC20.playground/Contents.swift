//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    private var states : [FSMState] = []
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.white
        setupStates()
        setupLines()
    }
    
    private func setupStates() {
        
        guard let skview = self.view else {return}
        
        let state1 = FSMState(color: .black)
        
        state1.position = CGPoint(x: -160, y: -50)
        self.addChild(state1)
        states.append(state1)
        
        let state2 = FSMState(color: .black)
               
        state2.position = CGPoint(x: -40, y: 210)
        self.addChild(state2)
        states.append(state2)
        
        
        let state3 = FSMState(color: .black)
               
        state3.position = CGPoint(x: 160, y: 50)
        self.addChild(state3)
        states.append(state3)
    }
    
    private func setupLines() {
        let line1 = FSMLine(from: states[0].edgePosition(at: CGFloat.pi/1.3), to: states[1].edgePosition(at: CGFloat.pi), dx: 1.2, dy: 0.5)
        
        self.addChild(line1)
        
        
        let line2 = FSMLine(from: states[0].edgePosition(at: -CGFloat.pi/8), to: states[2].edgePosition(at: CGFloat.pi*1.2), dx: -0.3, dy: -3)
        self.addChild(line2)
        
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        let state1 = FSMState(color: .white)
      
        print(pos)
        state1.position = pos
        
        self.addChild(state1)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


/// Class State


public class FSMState: SKShapeNode {
    
    public var radius: CGFloat = 0.0
    
    public init(color: UIColor = UIColor.white) {
        super.init()
        self.setDraw(color: color)
    }
    
    public override init() {
        super.init()
        self.setDraw(color: UIColor.white)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restAnimation() {
        let scale = SKAction.scaleX(by: 1.15, y: 1.12, duration: 2.0)
        self.run(.repeatForever(.sequence([scale, scale.reversed()])))
    }
    
    private func setDraw(color: UIColor) {
        
        let side = 50.0
        self.radius = CGFloat(side/2.0)
        
        let path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side))
        
        self.path = path.cgPath
        
        self.strokeColor = color
    }
    
    public func edgePosition(at angle: CGFloat) -> CGPoint {
        
        let newX = self.position.x + radius*cos(angle)
        let newY = self.position.y + radius*sin(angle)
        
        return CGPoint(x: newX, y: newY)
        
    }
}




class FSMLine: SKShapeNode {
    
    public init(from point1: CGPoint, to point2: CGPoint, dx: CGFloat, dy: CGFloat) {
       super.init()
        self.setDraw(start: point1, end: point2, dx: dx, dy: dy)
    }

    public required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func setDraw(start: CGPoint, end: CGPoint, dx: CGFloat, dy: CGFloat) {
        
        let arrow = UIBezierPath()
        
        let ctrlPoint = CGPoint(x: start.x*dx, y: end.y*dy )
        arrow.addArrow(start: start, end: end, controlPoint: ctrlPoint, pointerLineLength: 10, arrowAngle: CGFloat.pi/8)
        self.path = arrow.cgPath
        self.strokeColor = .black
    }
}



extension UIBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, controlPoint: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        self.move(to: start)
       // self.addLine(to: end)
        
        let controlPoint = controlPoint
        
        self.addQuadCurve(to: end, controlPoint: controlPoint)
        
        let startEndAngle = atan((end.y - controlPoint.y) / (end.x - controlPoint.x)) + ((end.x - controlPoint.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        self.addLine(to: arrowLine1)
        self.move(to: end)
        self.addLine(to: arrowLine2)
    }
}




// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
    
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
