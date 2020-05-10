//
//  FSMOutput.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 10/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import SpriteKit

public class FSMOutput: SKLabelNode {


    private var background: SKShapeNode!
    
    public override init() {
        super.init()
        
        self.setBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setBackground() {
        print("OK!")
        background = SKShapeNode()
        background.path = UIBezierPath(roundedRect: CGRect(x: self.position.x - 15.0 , y: self.position.y - 40.0, width: 30.0, height: 80.0), cornerRadius: 3.0).cgPath
        
        background.fillColor = UIColor(hexString: "#FDFDFD")
        background.strokeColor = UIColor(hexString: "#DFD8CD")
        background.lineWidth = 4
        background.zPosition = -1
        self.addChild(background)
    }
    
    
    public func update(text: String) {
        
        self.text = text
        self.updateBackground()
    }
    
    public func updateBackground() {
        
        background.path = UIBezierPath(roundedRect: CGRect(x: -(self.frame.width + 30)/2.0 , y: -20, width: self.frame.width + 30, height: self.fontSize + 20), cornerRadius: 10.0).cgPath
    }
}
