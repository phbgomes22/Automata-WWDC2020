//
//  FSMOutput.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 10/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit
import PlaygroundSupport

public class FSMOutput: SKLabelNode {

    public var background: SKShapeNode!
    private var sizeFont: CGFloat = 0.0
    private var widthSize: CGFloat = 30.0
    
    public init(fontSize: CGFloat) {
        super.init()
        
        self.fontSize = fontSize
        sizeFont = fontSize
        self.setBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setBackground() {
        print("OK!")
        background = SKShapeNode()
        background.path = UIBezierPath(roundedRect: CGRect(x: self.position.x - 15.0 , y: self.position.y - 20.0, width: self.widthSize, height: self.fontSize + 20), cornerRadius: 3.0).cgPath
        
        background.fillColor = UIColor(hexString: "#FDFDFD")
        background.strokeColor = UIColor(hexString: "#DFD8CD")
        background.lineWidth = 4
        background.zPosition = -1
        self.addChild(background)
    }
    
    
    public func restAnimation() {
        let action = SKAction.scale(by: 1.07, duration: 1.0)
        let seq = SKAction.sequence([action, action.reversed()])
        
        self.run(.repeatForever(seq))
    }
    
    public func update(text: String) {
        self.text = (self.text ?? "") + text
        print("A")
        self.updateBackground(text: text)
        print("B")
    }
    
    
    public func updateBackground(text: String) {
        
        self.widthSize += 40.0
        if text.count > 1 {
            self.widthSize += 45.0
        }
        background.path = UIBezierPath(roundedRect: CGRect(x: -(self.widthSize)/2.0 , y: -20, width:         self.widthSize, height: sizeFont + 20), cornerRadius: 10.0).cgPath
        print("C")
    }
}
