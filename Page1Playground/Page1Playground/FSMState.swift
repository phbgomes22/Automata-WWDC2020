//
//  FSMState.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 07/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit

// MARK: - FSMState


public class FSMState: SKShapeNode {
    
    private var label: SKLabelNode = SKLabelNode()
    public var radius: CGFloat = 0.0
    private var glowBody: SKShapeNode = SKShapeNode()
    private var arrayColors: [UIColor] = [UIColor(hexString: "#511845"),
                                          UIColor(hexString: "#900c3f"),
                                          UIColor(hexString: "#c70039"),
                                          UIColor(hexString: "#ff5733")]
    private var holder: SKShapeNode = SKShapeNode()
    private var holderPos: CGPoint = .zero
    
    private var arcs: [SKShapeNode] = []
    
    public init(color: UIColor = UIColor.white, side: CGFloat = 50.0, position: CGPoint, name: String) {
        super.init()
        self.name = name
        self.radius = CGFloat(side/2.0)
        self.position = position
        self.path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side)).cgPath
        var count: CGFloat = 0.0
        for retroColor in arrayColors {
            self.setDraw(color: retroColor, side: side - count, position: position)
            count += side/CGFloat(arrayColors.count)
        }
        
        self.setGlow()
        self.setHolder()
    }
    
    public override init() {
        super.init()
        self.setDraw(color: UIColor.white, side: 50.0, position: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHolder() {
        
        //holder.position = self.position
        let lambda: CGFloat = 1.35
        
        
        let holderPath = UIBezierPath()
        
        holderPath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: self.radius*lambda, startAngle: .pi*1.1, endAngle:  -.pi*0.45, clockwise: false)
        
        let newCenter = CGPoint(x: -self.radius*1.25, y: -self.radius*1.5)
        self.holderPos = newCenter
        holderPath.addArc(withCenter: newCenter, radius: self.radius*0.7, startAngle: .pi*0.0, endAngle:  .pi/2, clockwise: false)
        
        holderPath.close()
        holder.path = holderPath.cgPath
        holder.strokeColor = UIColor(hexString: "#DFD8CD")
        holder.lineWidth = 6
        holder.fillColor = UIColor.white
        self.addChild(holder)
        holder.zPosition = -1
        
        self.addChild(label)
    }
    
    public func getOutput() -> String {
        return self.label.text ?? ""
    }
    
    public func setOutput(text: String, labelPos: CGPoint, rotate: CGFloat) {
        self.label.text = text
        self.label.fontName = "Futura-Bold"
        self.label.fontColor = UIColor(hexString: "#333333")
        self.label.fontSize = 30
                
        let skaction = SKAction.rotate(byAngle: rotate, duration: 0.0)
        holder.run(skaction)
        self.label.position = labelPos
    }
    
    private func setDraw(color: UIColor, side: CGFloat, position: CGPoint) {
        let side = side
        let arc = SKShapeNode()
        
        let path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side))
        arc.path = path.cgPath
        arc.strokeColor = color
        arc.lineWidth = side/10
        arc.fillColor = color
        arcs.append(arc)
        self.addChild(arc)
    }
    
    
    private func setGlow() {
        self.glowBody.path = self.path
        self.glowBody.strokeColor = UIColor(hexString: "#511845").withAlphaComponent(0.06)
        self.glowBody.glowWidth = 7.0
        self.glowBody.zPosition = -1
        self.addChild(glowBody)
    }

    
    
    public func gotTouched(view: SKView) {
      
        var count:CGFloat = 1.0
        for arc in arcs {
            let scaleAction = SKAction.scale(by: 1.0 + 0.15*count, duration: 0.22)
            let seqScale = SKAction.sequence([scaleAction, scaleAction.reversed()])
            arc.run(seqScale)
            count += 1.0
        }
        
        
        let originalTransform = view.transform
        let scaled = originalTransform.scaledBy(x: 1.01, y: 1.01)

        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseOut, .autoreverse], animations: {
            view.transform = scaled
        }, completion: { (_) in
            view.transform = originalTransform
        })
        
        let sound = Sound.randomSound()
        let action = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        self.run(action)
    }
    

  
    
    public func edgePosition(at angle: CGFloat, lambdaRadius: CGFloat = 1.0) -> CGPoint {
        
        let newX = self.position.x + (radius*lambdaRadius)*cos(angle)
        let newY = self.position.y + (radius*lambdaRadius)*sin(angle)
        
        return CGPoint(x: newX, y: newY)
    }
    
    private func internalEdge(at angle: CGFloat, lambdaRadius: CGFloat = 1.0) -> CGPoint {
        
        let newX = (radius*lambdaRadius)*cos(angle)
        let newY = (radius*lambdaRadius)*sin(angle)
        
        return CGPoint(x: newX, y: newY)
    }
}


public func edgeCircle(pos: CGPoint, at angle: CGFloat, radius: CGFloat) -> CGPoint {

    let newX = pos.x + (radius)*cos(angle)
    let newY = pos.y + (radius)*sin(angle)
    
    return CGPoint(x: newX, y: newY)
}


public struct Sound {
    
    private static var partialNotes = ["0b-b0", "2b-d1", "3b-e1", "4b-f1", "5b-g1", "6b-a1"]
    private static var lastRandom: Int = 0
    private static var allNodes = ["0b-b0", "1b-c1", "2b-d1", "3b-e1", "4b-f1", "5b-g1", "6b-a1", "7b-a1", "8b-b1"]
    
    public static func randomSound() -> String {
        var random = Int.random(in: 0...partialNotes.count - 1)
        while random == Sound.lastRandom {
            random = Int.random(in: 0...partialNotes.count - 1)
        }
        Sound.lastRandom = random
        let str = Sound.partialNotes[random] + ".wav"
        print(str)
        
        return str //SKAudioNode(fileNamed: str)
    }
    
}
