//
//  FSMLine.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 07/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit
import UIKit
import PlaygroundSupport
import GameplayKit

// MARK: - FSMLine

public class FSMLine: SKSpriteNode {
    
    public enum Style {
        case page1
        case normal
        case page2
    }
    
    private var style: Style = .normal
    private var body: SKShapeNode = SKShapeNode()
    private var label: SKLabelNode = SKLabelNode()
    private var glowBody: SKShapeNode = SKShapeNode()
    private var labelSpriteNode = SKSpriteNode()
    private var controlPos = CGPoint()
    private var colorLabel: SKShapeNode!
    
    private var headSize: CGFloat = 0.0
    
    public init(from point1: CGPoint, to point2: CGPoint, dx: CGFloat, dy: CGFloat, headSize: CGFloat = 20.0, name: String, style: Style) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.headSize = headSize
        self.name = name
        self.style = style
        self.setDraw(start: point1, end: point2, dx: dx, dy: dy)
        self.setGlow()
    }
    
    
    public init(from point1: CGPoint, to point2: CGPoint, dx1: CGFloat, dy1: CGFloat, dx2: CGFloat, dy2: CGFloat, headSize: CGFloat, name: String, style: Style) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.headSize = headSize
        self.name = name
        self.style = style
        self.setDraw(start: point1, end: point2, dx1: dx1, dy1: dy1, dx2: dx2, dy2: dy2, headSize: headSize)
        setGlow()
    }

    public required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    public func setLabel(at pos: CGPoint, text: String, fontSize: CGFloat = 40) {
        
        self.label.fontSize = fontSize
        
        var spriteImage = emojiToImage(text: text, size: fontSize)
        if self.style == .normal {
            if let image = spriteImage.noir {
                spriteImage = image
            }// else
        }// else
        
        self.labelSpriteNode.size = CGSize(width: fontSize, height: fontSize)
        self.labelSpriteNode.texture = SKTexture.init(image: spriteImage)
        self.labelSpriteNode.color = .clear
        self.addChild(labelSpriteNode)
        self.labelSpriteNode.position = CGPoint(x: pos.x, y:  pos.y + fontSize/2)
        self.labelSpriteNode.zPosition = 10.0
        
    }
    
    public func setColor(at pos: CGPoint, fontSize: CGFloat = 30, color: UIColor) {
        
        colorLabel = SKShapeNode(circleOfRadius: (fontSize)/2)
        colorLabel.fillColor = color
        colorLabel.position = CGPoint(x: pos.x, y:  pos.y + (fontSize)/2 )
        colorLabel.lineWidth = 3.5
        colorLabel.strokeColor = self.body.strokeColor.withAlphaComponent(0.15)
        self.addChild(colorLabel)
    }
    
    
    public func gotUsed(scene: SKScene, completion: @escaping()->()) {
        
        let action = SKAction.scaleX(by: 1.02, y: 1.02, duration: 0.2)
        let seq = SKAction.sequence([action, action.reversed(), SKAction.wait(forDuration: 0.4)])
        
        let fade = SKAction.fadeAlpha(by: 10.0, duration: 0.2)
        let group = SKAction.group([seq, .sequence([fade, fade.reversed()])])
        
        self.glowBody.run(group)
        self.body.run(seq) {
            completion()
        }
        
        
        let sound = Sound.lineNote
        let playSound = SKAction.playSoundFileNamed(sound, waitForCompletion: true)
        self.run(playSound)
        
    }
    
    
    private func setDraw(start: CGPoint, end: CGPoint, dx1: CGFloat, dy1: CGFloat, dx2: CGFloat, dy2: CGFloat, headSize: CGFloat) {
        let arrow = UIBezierPath()
        
        let ctrlPoint1 = CGPoint(x: start.x*dx1, y: end.y*dy1)
        let ctrlPoint2 = CGPoint(x: start.x*dx2, y: end.y*dy2)
        self.controlPos = ctrlPoint1
        
        arrow.move(to: start)
        arrow.addCurve(to: end, controlPoint1: ctrlPoint1, controlPoint2: ctrlPoint2)
        arrow.addArrowHead(end: end, controlPoint: ctrlPoint2, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
        arrow.move(to: end)
        arrow.addCurve(to:start, controlPoint1: ctrlPoint2, controlPoint2: ctrlPoint1)
        arrow.close()
        
        self.body.path = arrow.cgPath
        self.body.lineWidth = 3.0
        self.addChild(body)
        
        colorNode()
    }
    
    private func colorNode() {
        
        switch self.style {
        case.normal:
            self.body.strokeColor = UIColor(hexString: "#999999")
            self.body.fillColor = UIColor(hexString: "#999999")
        case .page1:
            self.body.strokeColor = UIColor(hexString: "#511845")
            self.body.fillColor = UIColor(hexString: "#511845")
        case .page2:
            self.body.strokeColor = UIColor(hexString: "#512c96")
            self.body.fillColor = UIColor(hexString: "#512c96")
        }
        
    }
    
    private func setGlow() {
        self.glowBody.path = self.body.path
        self.glowBody.strokeColor = UIColor(hexString: "#511845").withAlphaComponent(0.08)
        self.glowBody.glowWidth = 7.0
        self.glowBody.zPosition = -1
        self.addChild(glowBody)
    }

    private func setDraw(start: CGPoint, end: CGPoint, dx: CGFloat, dy: CGFloat) {
        
        let bodyPath = UIBezierPath()
        
        let ctrlPoint = CGPoint(x: start.x*dx, y: end.y*dy )
        self.controlPos = ctrlPoint
        bodyPath.addArrowBody(start: start, end: end, controlPoint: ctrlPoint)
        bodyPath.addArrowHead(end: end, controlPoint: ctrlPoint, pointerLineLength: self.headSize + 1, arrowAngle: CGFloat.pi/8)
        bodyPath.addArrowBody(start: end, end: start, controlPoint: ctrlPoint)
        bodyPath.close()
        self.body.path = bodyPath.cgPath
        self.body.lineWidth = 3.0
        self.addChild(body)
        
        colorNode()
    }
    
    var scaleLabel: SKAction = SKAction.sequence([ SKAction.scale(by: 1.3, duration: 0.3),  SKAction.scale(by: 1.2, duration: 0.3).reversed()])
    
    public func animateLabel() {
        
        colorLabel?.run(scaleLabel)
    }
    
    
}

