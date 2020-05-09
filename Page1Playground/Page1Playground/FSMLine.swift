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

    private var body: SKShapeNode = SKShapeNode()
    private var label: SKLabelNode = SKLabelNode()
    private var bodyVertices: [CGPoint] = []
    
    private var gradientMaskBody: CAShapeLayer = CAShapeLayer()
    private var curveLayerBody: CAShapeLayer = CAShapeLayer()
    
    private var headSize: CGFloat = 0.0
    
    public init(from point1: CGPoint, to point2: CGPoint, dx: CGFloat, dy: CGFloat, headSize: CGFloat = 30.0) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.headSize = headSize
        self.setDraw(start: point1, end: point2, dx: dx, dy: dy)
    }
    
    
    public init(from point1: CGPoint, to point2: CGPoint, dx1: CGFloat, dy1: CGFloat, dx2: CGFloat, dy2: CGFloat, headSize: CGFloat) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.headSize = headSize
        self.setDraw(start: point1, end: point2, dx1: dx1, dy1: dy1, dx2: dx2, dy2: dy2, headSize: headSize)
    }

    public required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    public func setLabel(at pos: CGPoint, text: String) {
        self.label.text = text
        
        self.addChild(label)
        self.label.position = pos
    }
    
    public func gotUsed(scene: SKScene) {
        
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.duration = 0.2
        
       // let pathsUI2 = createBodyUI(view: scene.view!, scene: scene)
        animation.toValue = 12
        animation.autoreverses = true
     //   animation.toValue = pathsUI2.full.cgPath
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
        
        // The next two line preserves the final shape of animation,
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        curveLayerBody.add(animation, forKey: "moving")
        gradientMaskBody.add(animation, forKey: "moving")
        
    
    }
    
    private func setDraw(start: CGPoint, end: CGPoint, dx1: CGFloat, dy1: CGFloat, dx2: CGFloat, dy2: CGFloat, headSize: CGFloat) {
        let arrow = UIBezierPath()
        
        let ctrlPoint1 = CGPoint(x: start.x*dx1, y: end.y*dy1)
        let ctrlPoint2 = CGPoint(x: start.x*dx2, y: end.y*dy2)
        
        arrow.move(to: start)
        arrow.addCurve(to: end, controlPoint1: ctrlPoint1, controlPoint2: ctrlPoint2)
        arrow.addArrowHead(end: end, controlPoint: ctrlPoint2, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
        arrow.move(to: end)
        arrow.addCurve(to:start, controlPoint1: ctrlPoint2, controlPoint2: ctrlPoint1)
        arrow.close()
        
        bodyVertices = [start, end, ctrlPoint1, ctrlPoint2]
        self.body.path = arrow.cgPath
        self.body.strokeColor = UIColor(hexString: "#333333")
        self.body.fillColor = UIColor(hexString: "#333333")
        self.body.lineWidth = 3.0
        self.addChild(body)
    }

    private func setDraw(start: CGPoint, end: CGPoint, dx: CGFloat, dy: CGFloat) {
        
        let bodyPath = UIBezierPath()
        
        let ctrlPoint = CGPoint(x: start.x*dx, y: end.y*dy )
        bodyPath.addArrowBody(start: start, end: end, controlPoint: ctrlPoint)
        bodyPath.addArrowHead(end: end, controlPoint: ctrlPoint, pointerLineLength: 30, arrowAngle: CGFloat.pi/8)
        bodyPath.addArrowBody(start: end, end: start, controlPoint: ctrlPoint)
        bodyPath.close()
        bodyVertices = [start, end, ctrlPoint]
        self.body.path = bodyPath.cgPath
        self.body.strokeColor = UIColor(hexString: "#333333")
        self.body.fillColor = UIColor(hexString: "#333333")
        self.body.lineWidth = 3.0
        self.addChild(body)
        
    }
    
    private func createBodyUI(view: SKView, scene: SKScene) -> (oneWay: UIBezierPath, full: UIBezierPath) {
        
        let vertices = self.bodyVertices
        let path = UIBezierPath()
        let pathFull = UIBezierPath()
        
        let firstPos = view.convert(vertices[0], from: scene)
        let secondPos = view.convert(vertices[1], from: scene)
        let thirdPos = view.convert(vertices[2], from: scene)
        
        if vertices.count == 3 {
            path.addArrowBody(start: firstPos, end: secondPos, controlPoint: thirdPos)
            path.addArrowHead(end: secondPos, controlPoint: thirdPos, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
            
            pathFull.addArrowBody(start: firstPos, end: secondPos, controlPoint: thirdPos)
            pathFull.addArrowHead(end: secondPos, controlPoint: thirdPos, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
            pathFull.addArrowBody(start: secondPos, end: firstPos, controlPoint: thirdPos)
        } else {
            let fourthPos = view.convert(vertices[3], from: scene)
            path.addArrowBody(start: firstPos, end: secondPos, controlPoint: fourthPos)
            path.addArrowHead(end: secondPos, controlPoint: fourthPos, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
            
            pathFull.move(to: firstPos)
            pathFull.addCurve(to: secondPos, controlPoint1: thirdPos, controlPoint2: fourthPos)
            pathFull.addArrowHead(end: secondPos, controlPoint: fourthPos, pointerLineLength: self.headSize, arrowAngle: CGFloat.pi/8)
            pathFull.addCurve(to: firstPos, controlPoint1: fourthPos, controlPoint2: thirdPos)
            
        }
        
        return (oneWay: path, full: pathFull)
    }
    
    public func addGradient(view: SKView, scene: SKScene) {
        
        // BODY --
        
        let pathsUI2 = createBodyUI(view: view, scene: scene)
        
        draweCurve(path: pathsUI2.oneWay, fullPath: pathsUI2.full,  view: view)
        
    }
    
    
    private func draweCurve(path: UIBezierPath, fullPath: UIBezierPath, view: SKView) {
        // ------- 1 --------
        curveLayerBody = CAShapeLayer()
        curveLayerBody.contentsScale = UIScreen.main.scale
        curveLayerBody.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height))
        curveLayerBody.fillColor = UIColor.clear.cgColor
        curveLayerBody.strokeColor = UIColor.clear.cgColor
        curveLayerBody.lineWidth = 4
        curveLayerBody.path = fullPath.cgPath
        
        // ------- 2 --------
        // close the path on its self
        addGradientLayer(to: curveLayerBody, path: fullPath)
        
        view.layer.addSublayer(curveLayerBody)
    }

    private func addGradientLayer(to layer: CALayer, path: UIBezierPath) {
        // ------- 3 --------
        gradientMaskBody = CAShapeLayer()
        gradientMaskBody.contentsScale = UIScreen.main.scale
        // ------- 4 --------
        gradientMaskBody.strokeColor = UIColor.white.cgColor
        gradientMaskBody.path = path.cgPath
        gradientMaskBody.lineWidth = 5

        // ------- 5 --------
        let gradientLayer = CAGradientLayer()
        // ------- 6 --------
        gradientLayer.mask = gradientMaskBody
        gradientLayer.frame = layer.frame
        gradientLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.colors = CAGradientLayer.pg1Colors
        gradientLayer.startPoint = CAGradientLayer.pg1StartPoint
        gradientLayer.endPoint = CAGradientLayer.pg1EndPoint
        
        layer.addSublayer(gradientLayer)
        
    }
}
