//: A SpriteKit based Playground

import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    private var states : [FSMState] = []
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#F6F8E8")
             //UIColor(hexString: "#FFFBF3")
        setupCamera()
        setupStates()
        setupLines()
    }
    
    private func setupStates() {
        
        let state1 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 80,
                        position: CGPoint(x: -160, y: -50),
                        name: "state1")
        state1.setGradient(view: self.view!, scene: self)
        self.addChild(state1)
        states.append(state1)
        
        let state2 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 50,
                        position: CGPoint(x: -40, y: 210),
                        name: "state2")
        state2.setGradient(view: self.view!, scene: self)
               
        self.addChild(state2)
        states.append(state2)
        
        let state3 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 65,
                        position: CGPoint(x: 160, y: 50),
                        name: "state3")
        state3.setGradient(view: self.view!, scene: self)
               
        self.addChild(state3)
        states.append(state3)
    }
    
    private func setupLines() {
        let line1 = FSMLine(from: states[0].edgePosition(at: CGFloat.pi/1.3), to: states[1].edgePosition(at: CGFloat.pi), dx: 1.2, dy: 0.5)
        self.addChild(line1)
        line1.addGradient(view: self.view!, scene: self)
        
        let line2 = FSMLine(from: states[0].edgePosition(at: -CGFloat.pi/8), to: states[2].edgePosition(at: CGFloat.pi*1.4), dx: -0.5, dy: -5.5)
        self.addChild(line2)
        line2.addGradient(view: self.view!, scene: self)
        
        
        let line3 = FSMLine(from: states[1].edgePosition(at: -CGFloat.pi/2.3), to: states[0].edgePosition(at: CGFloat.pi/3), dx: 1.2, dy: -0.3)
        self.addChild(line3)
        line3.addGradient(view: self.view!, scene: self)
        
        
        let line4 = FSMLine(from: states[2].edgePosition(at: CGFloat.pi*0.9), to: states[1].edgePosition(at: -CGFloat.pi/8), dx: 0.6, dy: 0.52)
        self.addChild(line4)
        line4.addGradient(view: self.view!, scene: self)
        
        
        let line5 = FSMLine(from: states[2].edgePosition(at: CGFloat.pi*0.6), to: states[2].edgePosition(at: CGFloat.pi*0.3), dx1: 0.8, dy1: 3.2, dx2: 1.6, dy2: 2.0, headSize: 20)
        self.addChild(line5)
        line5.addGradient(view: self.view!, scene: self)
        
    }
    
    
    private func setupCamera() {
//        let cameraNode = SKCameraNode(fileNamed: "cameraNode")!
//        cameraNode.position = CGPoint(x: 0,y: 0)
//       // cameraNode.isUserInteractionEnabled = false
//        self.addChild(cameraNode)
//        self.camera = cameraNode
    }
    
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print(pos)
        print(self.nodes(at: pos).count)
        for node in self.nodes(at: pos) {
            if let state = node as? FSMState {
                state.gotTouched(scene: self)
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


// MARK: - Extensions

extension UIBezierPath {
    func addArrowBody(start: CGPoint, end: CGPoint, controlPoint: CGPoint) {
        self.move(to: start)
        
        let controlPoint = controlPoint
        
        self.addQuadCurve(to: end, controlPoint: controlPoint)
    }
    
    func addArrowHead(end: CGPoint, controlPoint: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) -> (left: CGPoint, right: CGPoint) {
        
        self.move(to: end)
        
        let controlPoint = controlPoint
        
        let startEndAngle = atan((end.y - controlPoint.y) / (end.x - controlPoint.x)) + ((end.x - controlPoint.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        self.addLine(to: arrowLine1)
        self.addLine(to: arrowLine2)
        self.close()
        
        return (left: arrowLine1, right: arrowLine2)
    }

}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



extension CAGradientLayer {
    
    // Page 1
    static let pg1Colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
    static let pg1StartPoint = CGPoint(x: 0.6, y: 0.1)
    static let pg1EndPoint = CGPoint(x: 0.3, y: 0.8)
    
}
