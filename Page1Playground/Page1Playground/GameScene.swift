//: A SpriteKit based Playground

import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    private var states : [FSMState] = []
    private var lines : [FSMLine] = []
    
    private var isFirstTap: Bool = true
    public var fsmString: String = "☎️🎱🔥🎩🎩🐶"
    
    private var winLabel: UILabel = UILabel()
    
    override public func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(hexString: "#F6F8E8")
        
    }
    
    private func setLabel() {
        
        let pos = self.convertPoint(toView: CGPoint(x: 0, y: -300))
        
        winLabel = UILabel(frame: CGRect(x: pos.x, y: pos.y, width: 300.0, height: 100.0))
        let text = "Great!"
        winLabel.text = text
        winLabel.font = UIFont.systemFont(ofSize: 80.0, weight: .bold)
        if winLabel.applyGradientWith(startColor: UIColor(hexString: "#30D5C8"), endColor: UIColor(hexString: "#2E856E")) {
            print("Gradient applied!")
        }
        else {
            print("Could not apply gradient")
            winLabel.textColor = .black
        }
        
        self.view!.addSubview(winLabel)
        
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
        line1.setLabel(at: CGPoint(x: -210.0, y: 90.0), text: "☎️")
        lines.append(line1)
        
        let line2 = FSMLine(from: states[0].edgePosition(at: -CGFloat.pi/8), to: states[2].edgePosition(at: CGFloat.pi*1.4), dx: -0.5, dy: -5.5)
        self.addChild(line2)
        line2.addGradient(view: self.view!, scene: self)
        line2.setLabel(at: CGPoint(x: -40.0, y: 30.0), text: "🎱")
        lines.append(line2)
        
        
        let line3 = FSMLine(from: states[1].edgePosition(at: -CGFloat.pi/2.3), to: states[0].edgePosition(at: CGFloat.pi/3), dx: 1.2, dy: -0.3)
        self.addChild(line3)
        line3.addGradient(view: self.view!, scene: self)
        line3.setLabel(at: CGPoint(x: 50.0, y: -100.0), text: "🔥")
        lines.append(line3)
        
        
        let line4 = FSMLine(from: states[2].edgePosition(at: CGFloat.pi*0.9), to: states[1].edgePosition(at: -CGFloat.pi/8), dx: 0.6, dy: 0.52)
        self.addChild(line4)
        line4.addGradient(view: self.view!, scene: self)
        line4.setLabel(at: CGPoint(x: 90.0, y: 125.0), text: "🐶")
        lines.append(line4)
        
        
        let line5 = FSMLine(from: states[2].edgePosition(at: CGFloat.pi*0.6), to: states[2].edgePosition(at: CGFloat.pi*0.1), dx1: 0.9, dy1: 2.8, dx2: 1.8, dy2: 1.8, headSize: 20)
        self.addChild(line5)
        line5.addGradient(view: self.view!, scene: self)
        line5.setLabel(at: CGPoint(x: 215.0, y: 130.0), text: "🎩")
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
        
        if isFirstTap {
            self.setupBoard()
            isFirstTap = false
        }
        else {
//            let bool = self.automateFSM(delay: 4) { (ended) in
//                print(ended)
//            }
//            print(bool)
            
            DispatchQueue.main.async {
                self.lines[0].gotUsed(scene: self)
            }
        }
        for node in self.nodes(at: pos) {
            if let state = node as? FSMState {
                state.gotTouched(view: self.view!)
            }
        }
        
    }
    
    
    private func automateFSM(delay: Int, completion: @escaping (_ ended: Bool) -> ()) -> Bool {
        
        var currentState = FSMLogic.StatesPG1.first
        var bool = true
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .seconds(delay)) {
            for char in self.fsmString {
                let nextState = FSMLogic.fsm1(from: currentState, text: String(char))
                print(char)
                guard let nState = nextState else {
                    bool = false
                    print("ACABOU")
                    break
                }
                
                usleep(1500000)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    switch nState {
                    case .first:
                        self.states[0].gotTouched(view: self.view!)
                    case .second:
                        self.states[1].gotTouched(view: self.view!)
                    case .third:
                        self.states[2].gotTouched(view: self.view!)
                    }
                }
                
                
                currentState = nState
                
            }
            
            completion(bool)
        }
            
           

        return bool
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



extension CAGradientLayer {
    
    // Page 1
    static let pg1Colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
    static let pg1StartPoint = CGPoint(x: 0.6, y: 0.1)
    static let pg1EndPoint = CGPoint(x: 0.3, y: 0.8)
    
}

extension CGAffineTransform {
    public var scale: Double {
        return sqrt(Double(a * a + c * c))
    }
}

extension UILabel {

    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {

        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0

        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }

        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0

        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }

        let gradientText = self.text ?? ""

        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedString.Key.font : self.font ?? UIFont.systemFont(ofSize: 10)])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsPushContext(context)

        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)

        UIGraphicsPopContext()

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsEndImageContext()

        self.textColor = UIColor(patternImage: gradientImage)

        return true
    }

}
