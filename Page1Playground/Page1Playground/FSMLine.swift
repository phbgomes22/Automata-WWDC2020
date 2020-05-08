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
    
    private var head: SKShapeNode = SKShapeNode()
    private var body: SKShapeNode = SKShapeNode()
    private var headPos: CGPoint = CGPoint.zero
    private var headVertices: [CGPoint] = []
    private var bodyVertices: [CGPoint] = []
    
    public init(from point1: CGPoint, to point2: CGPoint, dx: CGFloat, dy: CGFloat) {
        super.init(texture: nil, color: .clear, size: .zero)
        self.setDraw(start: point1, end: point2, dx: dx, dy: dy)
    }

    public required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func setDraw(start: CGPoint, end: CGPoint, dx: CGFloat, dy: CGFloat) {
        
        let arrow = UIBezierPath()
        
        let ctrlPoint = CGPoint(x: start.x*dx, y: end.y*dy )
        arrow.addArrowBody(start: start, end: end, controlPoint: ctrlPoint)
        bodyVertices = [start, end, ctrlPoint]
        self.body.path = arrow.cgPath
        self.body.strokeColor = .clear
        self.body.fillColor = .clear
        self.body.lineWidth = 3.0
       // self.body.isAntialiased = false
        self.addChild(body)
        
        let arrowHead = UIBezierPath()
        
        let vertices = arrowHead.addArrowHead(end: end, controlPoint: ctrlPoint, pointerLineLength: 30, arrowAngle: CGFloat.pi/8)
        self.head.path = arrowHead.cgPath
        self.head.strokeColor = .clear
        self.head.lineWidth = 2.0
        self.head.fillColor = .clear
        self.headPos = end
        
        headVertices = [vertices.left, vertices.right, end]
        
        self.addChild(head)
        
    }
    
    /// geths the cgpath written in spritekit and converts it to uikit
    private func createHeadUI(view: SKView, scene: SKScene) -> UIBezierPath {
        
        let vertices = self.headVertices
        let path = UIBezierPath()
        
        let firstPos = view.convert(vertices[0], from: scene)
        let secondPos = view.convert(vertices[1], from: scene)
        let thirdPos = view.convert(vertices[2], from: scene)
        
        path.move(to: firstPos)
        path.addLine(to: secondPos)
        path.addLine(to: thirdPos)
        path.close()
        return path
    }
    
    private func createBodyUI(view: SKView, scene: SKScene) -> (oneWay: UIBezierPath, full: UIBezierPath) {
        
        let vertices = self.bodyVertices
        let path = UIBezierPath()
        
        let firstPos = view.convert(vertices[0], from: scene)
        let secondPos = view.convert(vertices[1], from: scene)
        let thirdPos = view.convert(vertices[2], from: scene)
        
        path.addArrowBody(start: firstPos, end: secondPos, controlPoint: thirdPos)
        
        let pathFull = UIBezierPath()
        pathFull.addArrowBody(start: firstPos, end: secondPos, controlPoint: thirdPos)
        pathFull.addArrowBody(start: secondPos, end: firstPos, controlPoint: thirdPos)
        
        return (oneWay: path, full: pathFull)
    }
    
    public func addGradient(view: SKView, scene: SKScene) {
        
        // BODY --
        
        let pathsUI2 = createBodyUI(view: view, scene: scene)
        
        draweCurve(path: pathsUI2.oneWay, fullPath: pathsUI2.full,  view: view)
        
        // HEAD --
        
        let gradientLayer = CAGradientLayer()
        
        let pathUI = createHeadUI(view: view, scene: scene)
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradientLayer.colors = CAGradientLayer.pg1Colors
        gradientLayer.startPoint = CAGradientLayer.pg1StartPoint
        gradientLayer.endPoint = CAGradientLayer.pg1EndPoint
        
        let shapeMask = CAShapeLayer()

        shapeMask.path = pathUI.cgPath
        gradientLayer.mask = shapeMask
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private func draweCurve(path: UIBezierPath, fullPath: UIBezierPath, view: SKView) {
        // ------- 1 --------
        let curveLayer = CAShapeLayer()
        curveLayer.contentsScale = UIScreen.main.scale
        curveLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        curveLayer.fillColor = UIColor.clear.cgColor
        curveLayer.strokeColor = UIColor.clear.cgColor
        curveLayer.lineWidth = 4
        curveLayer.path = fullPath.cgPath
        // ------- 2 --------
        // close the path on its self
        addGradientLayer(to: curveLayer, path: fullPath)
        
        view.layer.addSublayer(curveLayer)
    }

    private func addGradientLayer(to layer: CALayer, path: UIBezierPath) {
        // ------- 3 --------
        let gradientMask = CAShapeLayer()
        gradientMask.contentsScale = UIScreen.main.scale
        // ------- 4 --------
        gradientMask.strokeColor = UIColor.white.cgColor
        gradientMask.path = path.cgPath
        gradientMask.lineWidth = 5

        // ------- 5 --------
        let gradientLayer = CAGradientLayer()
        // ------- 6 --------
        gradientLayer.mask = gradientMask
        gradientLayer.frame = layer.frame
        gradientLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.colors = CAGradientLayer.pg1Colors
        gradientLayer.startPoint = CAGradientLayer.pg1StartPoint
        gradientLayer.endPoint = CAGradientLayer.pg1EndPoint
        
        layer.addSublayer(gradientLayer)
    }
}
