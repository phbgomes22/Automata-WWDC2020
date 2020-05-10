//: A SpriteKit based Playground

import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    private var states : [FSMState] = []
    private var lines : [FSMLine] = []
    
    private var isFirstTap: Bool = true
    public var fsmString: String = "🤖🎱🔥🎩🎩🐶"
    public var firstState: FSMLogic.StatesPG1 = FSMLogic.StatesPG1.first
    
    private var wordLabel: SKLabelNode = SKLabelNode()
    
    override public func didMove(to view: SKView) {
        
        //self.backgroundColor = UIColor(hexString: "#F6F8E8")
        self.backgroundColor = UIColor(hexString: "#E4DED3")
        self.setupBoard()
        self.setWordLabel()
    }
    
    private func setWordLabel() {
        self.addChild(wordLabel)
        
        wordLabel.fontSize = 50
        wordLabel.position = CGPoint(x: 0.0, y: -250.0)
        wordLabel.fontColor = UIColor(hexString: "#333333")
        wordLabel.fontName =  "Futura-Bold"
        wordLabel.color = UIColor(hexString: "#FDFDFD")
    }
    
    private func setupBoard() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupStates()
            self.setupLines()
        }
    }
    
    private func setupStates() {
        
        let state1 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 75,
                        position: CGPoint(x: -160, y: -50),
                        name: "state1")
        self.addChild(state1)
        state1.setOutput(text: "N", labelPos: CGPoint(x: -48, y: -68), rotate: 0.0)
        states.append(state1)
        
        let state2 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 75,
                        position: CGPoint(x: -40, y: 210),
                        name: "state2")
        self.addChild(state2)
        state2.setOutput(text: "A", labelPos: CGPoint(x: 46, y: 46), rotate: .pi)
        states.append(state2)
        
        let state3 = FSMState(
                        color: UIColor(hexString: "#E3E3F0"),
                        side: 75,
                        position: CGPoint(x: 160, y: 50),
                        name: "state3")
               
        self.addChild(state3)
        state3.setOutput(text: "B", labelPos: CGPoint(x: 26, y: -82), rotate: .pi/3)
        states.append(state3)
    }
    
    private func setupLines() {
        let line1 = FSMLine(
                        from: states[0].edgePosition(at: CGFloat.pi/1.3),
                        to: states[1].edgePosition(at: CGFloat.pi, lambdaRadius: 1.4),
                        dx: 1.2,
                        dy: 0.5, name: "line1")
        self.addChild(line1)
        line1.setLabel(at: CGPoint(x: -210.0, y: 90.0), text: "🤖")
        lines.append(line1)
        
        let line2 = FSMLine(
                        from: states[0].edgePosition(at: -CGFloat.pi/8),
                        to: states[2].edgePosition(at: CGFloat.pi*1.35, lambdaRadius: 1.4),
                        dx: -0.3,
                        dy: -20.5, name: "line2")
        self.addChild(line2)
        line2.setLabel(at: CGPoint(x: 40.0, y: -90.0), text: "🔥")
        lines.append(line2)
        
        
        let line3 = FSMLine(
                        from: states[1].edgePosition(at: -CGFloat.pi/2.3),
                        to: states[0].edgePosition(at: CGFloat.pi/4, lambdaRadius: 1.4),
                        dx: 1.2,
                        dy: -0.3, name: "line3")
        self.addChild(line3)
        line3.setLabel(at: CGPoint(x: -30.0, y: 40.0), text: "🎱")
        lines.append(line3)
        
        
        let line4 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.9),
                        to: states[1].edgePosition(at: -CGFloat.pi/8, lambdaRadius: 1.4),
                        dx: 0.6,
                        dy: 0.52, name: "line4")
        self.addChild(line4)
        line4.setLabel(at: CGPoint(x: 90.0, y: 125.0), text: "🐶")
        lines.append(line4)
        
        
        let line5 = FSMLine(
                        from: states[2].edgePosition(at: CGFloat.pi*0.6),
                        to: states[2].edgePosition(at: CGFloat.pi*0.1, lambdaRadius: 1.4),
                        dx1: 0.9,  dy1: 2.8,
                        dx2: 1.8,  dy2: 1.8,
                        headSize: 15, name: "line5")
        self.addChild(line5)
        line5.setLabel(at: CGPoint(x: 225.0, y: 130.0), text: "🎩")
        lines.append(line5)
        
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
        self.automateFSM(delay: 0) { (ended) in
            print(ended)
        }
        
        for node in self.nodes(at: pos) {
            if let state = node as? FSMState {
                state.gotTouched(view: self.view!)
            }
        }
        
    }
    
    
    private func automateFSM(delay: Int, completion: @escaping (_ ended: Bool) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .seconds(delay)) {
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
                
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    currStateNode.gotTouched(view: self.view!)
                    
                    let output = currStateNode.getOutput()
                    
                    self.wordLabel.text = (self.wordLabel.text ?? "") + output
                }
                
                usleep(1400000)
                
                // sets next state
                guard let nextState = nState else { // if there is no next state, the line wont animate
                    if(char != "X") {
                        bool = false
                    }
                    break
                }
                currentState = nextState
                
                guard let lNode = nLineNode else { print("WOW, something went very wrong!");break}
                
                DispatchQueue.main.async {
                    print(lNode.name ?? "no name")
                    lNode.gotUsed(scene: self)
                }
                
                usleep(600000)
                
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

//
//
// MARK: - Extensions

extension UIBezierPath {
    func addArrowBody(start: CGPoint, end: CGPoint, controlPoint: CGPoint) {
        self.move(to: start)
        
        let controlPoint = controlPoint
        
        self.addQuadCurve(to: end, controlPoint: controlPoint)
    }
    
    func addArrowHead(end: CGPoint, controlPoint: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        
        self.move(to: end)
        
        let controlPoint = controlPoint
        
        let startEndAngle = atan((end.y - controlPoint.y) / (end.x - controlPoint.x)) + ((end.x - controlPoint.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        self.addLine(to: arrowLine1)
        self.addLine(to: arrowLine2)
        self.close()
        
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
