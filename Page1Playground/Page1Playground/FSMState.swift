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
    private var isAnimating = false
    
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
        self.strokeColor = UIColor(hexString: "#AAAAAA")
        self.lineWidth = 3
        self.widthLine = side/10
        
    }
    
    public func setGradient(view: SKView, scene: SKScene) {
        strokeGradient = draweCurve(path: UIBezierPath(ovalIn: CGRect(x: -self.radius + 4, y: -self.radius + 4, width: 2*(self.radius - 4), height: 2*(self.radius - 4))).cgPath, view: view, scene: scene)
        
        // HEAD --
        
        fillGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        fillGradient.colors = CAGradientLayer.pg1Colors
        fillGradient.startPoint = CAGradientLayer.pg1StartPoint
        fillGradient.endPoint = CAGradientLayer.pg1EndPoint
        fillGradient.contentsScale = CGFloat(view.contentScaleFactor)
        
        let shapeMask = CAShapeLayer()
        let uiPos = scene.convertPoint(toView: self.position)
        print(uiPos)
        print(" - - - - -")
        shapeMask.position = uiPos
        shapeMask.path = self.path!
        fillGradient.mask = shapeMask
        view.layer.insertSublayer(fillGradient, at: 0)
        fillGradient.opacity = 0.0
    }
    
    public func gotTouched(view: SKView) {
        if(isAnimating) {return}
        //        // fill animation
        let gradientChangeAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.opacity))
        gradientChangeAnimation.duration = 0.15
        gradientChangeAnimation.toValue = 1.0
        gradientChangeAnimation.fromValue = 0.0
        gradientChangeAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        gradientChangeAnimation.autoreverses = true
        fillGradient.add(gradientChangeAnimation, forKey: "opacityFill")
        
        
        let strokeSize = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineWidth))
        strokeSize.duration = 0.15
        strokeSize.toValue = self.widthLine*0.2
        strokeSize.fromValue = self.widthLine
        strokeSize.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        strokeSize.autoreverses = true
        maskStrokeLayer.add(strokeSize, forKey: "opacityFill")

        let originalTransform = view.transform
        let scaled = originalTransform.scaledBy(x: 1.005, y: 1.01)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut, .autoreverse], animations: {
            view.transform = scaled
            self.isAnimating = true
        }, completion: { (_) in
            view.transform = originalTransform
            self.isAnimating = false
        })
    }
    
    
    private func draweCurve(path: CGPath, view: SKView, scene: SKScene) -> CAGradientLayer {
        // ------- 1 --------
        let curveLayer = CAShapeLayer()
        curveLayer.contentsScale = CGFloat(view.transform.scale)
        curveLayer.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height))
        // ------- 2 --------
        // close the path on its self
        let gl = addGradientLayer(to: curveLayer, path: path, at: view.convert(self.position, from: scene), view: view)
        
        view.layer.addSublayer(curveLayer)
        return gl
    }
    
    private func addGradientLayer(to layer: CALayer, path: CGPath, at pos: CGPoint, view: SKView) -> CAGradientLayer {
        // ------- 3 --------
        maskStrokeLayer = CAShapeLayer()
        maskStrokeLayer.contentsScale = CGFloat(view.transform.scale)
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
    
    public func edgePosition(at angle: CGFloat, lambdaRadius: CGFloat = 1.0) -> CGPoint {
        
        let newX = self.position.x + (radius*lambdaRadius)*cos(angle)
        let newY = self.position.y + (radius*lambdaRadius)*sin(angle)
        
        return CGPoint(x: newX, y: newY)
    }
}

