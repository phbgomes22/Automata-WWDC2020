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
    
    public var radius: CGFloat = 0.0
    private var widthLine: CGFloat = 0.0
    
    public init(color: UIColor = UIColor.white, side: CGFloat = 50.0, position: CGPoint, name: String) {
        super.init()
        self.setDraw(color: color, side: side, position: position)
        self.name = name
    }
    
    public override init() {
        super.init()
        self.setDraw(color: UIColor.white, side: 50.0, position: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restAnimation() {
        let scale = SKAction.scaleX(by: 1.5, y: 1.5, duration: 2.0)
        self.run(.repeatForever(.sequence([scale, scale.reversed()])))
    }
    
    private func setDraw(color: UIColor, side: CGFloat, position: CGPoint) {
        let side = side
        self.radius = CGFloat(side/2.0)
        
        let path = UIBezierPath(ovalIn: CGRect(x: -side/2.0, y: -side/2.0, width: side, height: side))
        self.path = path.cgPath
        self.position = position
        self.strokeColor = UIColor.clear
        self.lineWidth = 3
        self.widthLine = side/9.0
        
    }
    
    public func setGradient(view: SKView, scene: SKScene) {
        draweCurve(path: self.path!, view: view, scene: scene)
        restAnimation()
    }
    
    
    private func draweCurve(path: CGPath, view: SKView, scene: SKScene) {
        // ------- 1 --------
        let curveLayer = CAShapeLayer()
        curveLayer.contentsScale = UIScreen.main.scale
        curveLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        // ------- 2 --------
        // close the path on its self
        addGradientLayer(to: curveLayer, path: path, at: view.convert(self.position, from: scene))
        
        view.layer.addSublayer(curveLayer)
    }
    
    private func addGradientLayer(to layer: CALayer, path: CGPath, at pos: CGPoint) {
        // ------- 3 --------
        let gradientMask = CAShapeLayer()
        gradientMask.contentsScale = UIScreen.main.scale
        // ------- 4 --------
        gradientMask.strokeColor = UIColor.white.cgColor
        gradientMask.path = path
        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.position = pos
        gradientMask.lineWidth = self.widthLine
        
        // ------- 5 --------
        let gradientLayer = CAGradientLayer()
        // ------- 6 --------
        gradientLayer.mask = gradientMask
        gradientLayer.frame = layer.frame
        gradientLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.colors = CAGradientLayer.pg1Colors
        gradientLayer.startPoint = CAGradientLayer.pg1StartPoint
        gradientLayer.endPoint = CAGradientLayer.pg1EndPoint
        // ------- 8 --------
        layer.addSublayer(gradientLayer)
    }
    
    public func edgePosition(at angle: CGFloat) -> CGPoint {
        
        let newX = self.position.x + radius*cos(angle)
        let newY = self.position.y + radius*sin(angle)
        
        return CGPoint(x: newX, y: newY)
    }
    
}
