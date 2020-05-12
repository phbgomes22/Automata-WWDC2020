//
//  FSMState.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 07/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import PlaygroundSupport


// MARK: - FSMState


public class FSMState: SKShapeNode {
    
    public enum Style {
        case page1
        case normal
    }
    
    private var style: Style = .normal
    
    private var label: SKLabelNode = SKLabelNode()
    public var radius: CGFloat = 0.0
    private var glowBody: SKShapeNode = SKShapeNode()
    private var arrayColorsPG1: [UIColor] = [UIColor(hexString: "#511845"),
                                          UIColor(hexString: "#900c3f"),
                                          UIColor(hexString: "#c70039"),
                                          UIColor(hexString: "#ff5733")]
    private var holder: SKShapeNode = SKShapeNode()
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
        
        var count: CGFloat = 0.0
        var arrayColors: [UIColor] = []
        switch self.style {
        case .page1:
            arrayColors = arrayColorsPG1
        case .normal:
            arrayColors = [UIColor(hexString: "#666666")]
            self.alpha = 0.7
        }
        for retroColor in arrayColors {
            self.setDraw(color: retroColor, side: side - count, position: position)
            count += side/CGFloat(arrayColors.count)
        }
        
        self.setGlow()
    }
    
    public override init() {
        super.init()
        self.setDraw(color: UIColor.white, side: 50.0, position: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        case .page1:
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
    
    public func setOutput(text: String, labelPos: CGPoint, rotate: CGFloat) {
        
        self.setHolder()
        
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
        switch style {
        case .normal:
            break
        default:
            arc.fillColor = color
        }
        
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
