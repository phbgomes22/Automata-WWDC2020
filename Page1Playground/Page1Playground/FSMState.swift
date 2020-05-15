//
//  FSMState.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 07/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit
import UIKit
//import PlaygroundSupport
import GameplayKit

// MARK: - FSMState


public class FSMState: SKShapeNode {
    
    public enum Style {
        case page1
        case page2
        case page3
        case normal
    }
    
    private var style: Style = .normal
    
    private var label: SKLabelNode = SKLabelNode()
    public var radius: CGFloat = 0.0
    private var arrayColorsPG1: [UIColor] = [UIColor(hexString: "#511845"),
                                          UIColor(hexString: "#900c3f"),
                                          UIColor(hexString: "#c70039"),
                                          UIColor(hexString: "#ff5733")]
    
    private var arrayColorsPG2: [UIColor] = [UIColor(hexString: "#512c96"),
                                          UIColor(hexString: "#3c6f9c"),
                                          UIColor(hexString: "#dd6892"),
                                          UIColor(hexString: "#f9c6ba")]
    
    private var arrayColorsPG3: [UIColor] = [UIColor(hexString: "#211c76"),
                                             UIColor(hexString: "#210c66"),
                                             UIColor(hexString: "#110046"),
                                             UIColor(hexString: "#010026")]
    
    public var holder: SKShapeNode = SKShapeNode()
    private var holderPos: CGPoint = .zero
    
    private var arcs: [SKShapeNode] = []
    
    public init(side: CGFloat = 50.0, position: CGPoint, name: String, style: Style) {
        super.init()
        self.name = name
        self.radius = CGFloat(side/2.0)
        self.position = position
        self.path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side)).cgPath
        self.style = style
        
        setup(side: side)
    }
    
    private func setup(side: CGFloat) {
        
        var mult: CGFloat = 1.0
        var count: CGFloat = 0.0
        var arrayColors: [UIColor] = []
        switch self.style {
        case .page1:
            arrayColors = arrayColorsPG1
        case .normal:
            arrayColors = [UIColor(hexString: "#888888")]
            self.alpha = 0.7
        case .page2:
            arrayColors = arrayColorsPG2
        case .page3:
            arrayColors = arrayColorsPG3
            mult = 0.3
        }
        for retroColor in arrayColors {
            self.setDraw(color: retroColor, side: side - count, position: position)
            count += side*mult/CGFloat(arrayColors.count)
        }
        if self.style == .page3 {
            self.setGlow(size: side/5, color: arrayColorsPG3[0], at: self.arcs[0].path!)
            self.setGlow(size: side/4.5, color: arrayColorsPG3[3], at: self.arcs[3].path!)
        }
        
    }
    
    public override init() {
        super.init()
        self.setDraw(color: UIColor.white, side: 50.0, position: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func rotate(center: CGPoint) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y), radius: self.radius*5, startAngle: 0.0, endAngle: .pi, clockwise: true)
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y), radius: self.radius*5, startAngle: .pi, endAngle: 0.0, clockwise: true)
        
        let movement = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 100.0)
               
        self.run(.repeatForever(movement))
    }
    
    private func setHolder() {
        
        let lambda: CGFloat = 1.35
        let holderPath = UIBezierPath()
        
        holderPath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: self.radius*lambda, startAngle: .pi*1.1, endAngle:  -.pi*0.45, clockwise: false)
        
        let newCenter = CGPoint(x: -self.radius*1.25, y: -self.radius*1.5)
        self.holderPos = newCenter
        holderPath.addArc(withCenter: newCenter, radius: self.radius*0.7, startAngle: .pi*0.0, endAngle:  .pi/2, clockwise: false)
        
        holderPath.close()
        holder.path = holderPath.cgPath
        switch self.style {
        case .page1, .page2, .page3:
            holder.strokeColor = UIColor(hexString: "#DFD8CD")
            holder.fillColor = UIColor.white
        case .normal:
            holder.strokeColor = UIColor(hexString: "#DFD8CD")
            holder.fillColor = UIColor.white
        }
        holder.lineWidth = 6
        self.addChild(holder)
        holder.zPosition = -1
        
        self.addChild(label)
    }
    
    public func getOutput() -> String {
        return self.label.text ?? ""
    }
    
    public func setOutput(text: String, labelPos: CGPoint, rotate: CGFloat, size: CGFloat = 30.0) {
        
        self.setHolder()
        
        self.label.text = text
        self.label.fontName = "Futura-Bold"
        self.label.fontColor = UIColor(hexString: "#333333")
        self.label.fontSize = size
                
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
        switch style {
        case .normal:
            break
        default:
            arc.fillColor = color
        }
        
        arcs.append(arc)
        self.addChild(arc)
    }
    
    
    private func setGlow(size: CGFloat, color: UIColor, at path: CGPath) {

        let glowBody: SKShapeNode = SKShapeNode()
        
        glowBody.path = path
        glowBody.strokeColor = color.withAlphaComponent(0.8)
        glowBody.glowWidth = size
        glowBody.zPosition = -1
        addChild(glowBody)
    }

    
    
    public func gotTouched(view: SKView, completion: @escaping(Bool)->() ) {
      
        var count:CGFloat = 1.0
        for arc in arcs {
            let scaleAction = SKAction.scale(by: 1.0 + 0.15*count, duration: 0.3)
            let seqScale = SKAction.sequence([scaleAction, scaleAction.reversed()])
            arc.run(seqScale)
            count += 1.0
        }
        
        let sound = Sound.randomSound()
        let actionSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        let sequenceSound = SKAction.sequence([actionSound, SKAction.wait(forDuration: 0.75)])
        self.run(sequenceSound) {
           completion(true)
        }
        
        // move camera
        
        if let camera = self.scene!.camera {
            let scale = SKAction.scaleX(by: 1.01, y: 1.01, duration: 0.3)
            let move = SKAction.moveBy(x: 3.0, y: -2.0, duration: 0.3)
            let scaleAction = SKAction.sequence([scale, scale.reversed()])
            let moveAction = SKAction.sequence([move, move.reversed()])
            let groupCamera = SKAction.group([scaleAction, moveAction])
            
            camera.run(groupCamera)
        } else {
            print("NO CAMERA")
        }
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
