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
    private var fillGradient = CAGradientLayer()
    private var strokeGradient = CAGradientLayer()
    private var maskStrokeLayer = CAShapeLayer()
    
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
        strokeGradient = draweCurve(path: self.path!, view: view, scene: scene)
        
        // HEAD --

        fillGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fillGradient.colors = CAGradientLayer.pg1Colors
        fillGradient.startPoint = CAGradientLayer.pg1StartPoint
        fillGradient.endPoint = CAGradientLayer.pg1EndPoint
        
        let shapeMask = CAShapeLayer()
        shapeMask.position = view.convert(self.position, from: scene)
        shapeMask.path = self.path!
        fillGradient.mask = shapeMask
        view.layer.insertSublayer(fillGradient, at: 0)
        fillGradient.opacity = 0.0
    }
    
    public func gotTouched(scene: SKScene) {
        
        //        // fill animation
        let gradientChangeAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.opacity))
        gradientChangeAnimation.duration = 0.15
        gradientChangeAnimation.toValue = 1.0
        gradientChangeAnimation.fromValue = 0.0
        gradientChangeAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        gradientChangeAnimation.repeatCount = 1
        gradientChangeAnimation.autoreverses = true
        fillGradient.add(gradientChangeAnimation, forKey: "opacityFill")
        
        
        let gradientColorChange = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        gradientColorChange.duration = 0.2
        gradientColorChange.toValue =  self.fillGradient.endPoint //CGPoint(x: 0.3, y: 0.8)
        gradientColorChange.fromValue = CGPoint(x: 0.3, y: 1.0)
        gradientColorChange.fillMode = CAMediaTimingFillMode.forwards
        gradientColorChange.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        gradientColorChange.repeatCount = 1
        gradientColorChange.isRemovedOnCompletion = false
        self.fillGradient.add(gradientColorChange, forKey: "colorFill")
        
        
        let strokePath = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        strokePath.duration = 0.15
        strokePath.toValue = UIBezierPath(ovalIn: CGRect(x: -self.radius*0.9, y: -self.radius*0.9, width: self.radius*1.8, height: 1.8*self.radius)).cgPath
        strokePath.fromValue = self.path!
        strokePath.repeatCount = 1
        strokePath.fillMode = CAMediaTimingFillMode.forwards
        strokePath.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        strokePath.autoreverses = true
        self.maskStrokeLayer.add(strokePath, forKey: "path")
        
        
        // animate tilt
        
        let view = scene.view!
        print("hun")
        let random: CGFloat = CGFloat(Int.random(in: -1...1))
        let random2: CGFloat = CGFloat(Int.random(in: -1...1))
        
        let originalTransform = view.transform
        let scaled = originalTransform.scaledBy(x: 1.02, y: 1.02)
        let scaledAndTranslated = scaled.translatedBy(x: 2*random, y: 2*random2)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut, .autoreverse], animations: {
            view.transform = scaledAndTranslated
        }, completion: { (_) in
            view.transform = originalTransform
        })
        
        let keyPath = random > 0 ? "transform.rotation.x" : "transform.rotation.y"

        let multiplier: Double = Bool.random() ? 1.0 : -1.0
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        rotation.toValue = multiplier*Double.pi/28
        rotation.duration = 0.3 // or however long you want ...
        rotation.isCumulative = false
        strokePath.fillMode = CAMediaTimingFillMode.forwards
        strokePath.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        strokePath.autoreverses = true
        view.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    
    private func draweCurve(path: CGPath, view: SKView, scene: SKScene) -> CAGradientLayer {
        // ------- 1 --------
        let curveLayer = CAShapeLayer()
        curveLayer.contentsScale = UIScreen.main.scale
        curveLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        // ------- 2 --------
        // close the path on its self
        let gl = addGradientLayer(to: curveLayer, path: path, at: view.convert(self.position, from: scene))
        
        view.layer.addSublayer(curveLayer)
        return gl
    }
    
    private func addGradientLayer(to layer: CALayer, path: CGPath, at pos: CGPoint) -> CAGradientLayer {
        // ------- 3 --------
        maskStrokeLayer = CAShapeLayer()
        maskStrokeLayer.contentsScale = UIScreen.main.scale
        // ------- 4 --------
        maskStrokeLayer.strokeColor = UIColor.white.cgColor
        maskStrokeLayer.path = path
        maskStrokeLayer.fillColor = UIColor.clear.cgColor
        maskStrokeLayer.position = pos
        maskStrokeLayer.lineWidth = self.widthLine
        
        // ------- 5 --------
        let gradientLayer = CAGradientLayer()
        // ------- 6 --------
        gradientLayer.mask = maskStrokeLayer
        gradientLayer.frame = layer.frame
        gradientLayer.contentsScale = UIScreen.main.scale
        
        gradientLayer.colors = CAGradientLayer.pg1Colors
        gradientLayer.startPoint = CAGradientLayer.pg1StartPoint
        gradientLayer.endPoint = CAGradientLayer.pg1EndPoint
        // ------- 8 --------
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
    
    public func edgePosition(at angle: CGFloat) -> CGPoint {
        
        let newX = self.position.x + radius*cos(angle)
        let newY = self.position.y + radius*sin(angle)
        
        return CGPoint(x: newX, y: newY)
    }
    
}
