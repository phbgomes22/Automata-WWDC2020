//
//  FSMLine.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 07/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit


// MARK: - FSMLine

public class FSMLine: SKSpriteNode {
    
    public enum Style {
        case page1
        case normal
    }
    
    private var style: Style = .normal
    private var body: SKShapeNode = SKShapeNode()
    private var label: SKLabelNode = SKLabelNode()
    private var glowBody: SKShapeNode = SKShapeNode()
    private var labelSpriteNode = SKSpriteNode()
    private var controlPos = CGPoint()
    
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
    
    public func setLabel(at pos: CGPoint, text: String) {
        
        if self.style == .normal {
            if let image = emojiToImage(text: text, size: 45).noir {
                self.labelSpriteNode.size = CGSize(width: self.label.fontSize, height: self.label.fontSize)
                self.labelSpriteNode.texture = SKTexture.init(image: image)
                self.labelSpriteNode.color = .clear
                self.addChild(labelSpriteNode)
                self.labelSpriteNode.position = pos
                self.labelSpriteNode.zPosition = 10.0
                return
            }// else
        }// else
        
        
        self.label.text = text
        self.addChild(label)
        self.label.position = pos
        self.label.zPosition = 10.0
        
        let shapeNode = SKShapeNode(circleOfRadius: 21.0)
        shapeNode.fillColor = .white
        shapeNode.position = CGPoint(x: pos.x, y:  pos.y + 10.5)
        shapeNode.lineWidth = 3.5
        shapeNode.strokeColor = self.body.strokeColor.withAlphaComponent(0.3)
        self.addChild(shapeNode)

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
        }
        
    }
    
    private func setGlow() {
        self.glowBody.path = self.body.path
        self.glowBody.strokeColor = UIColor(hexString: "#511845").withAlphaComponent(0.06)
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
    
    
    
}

