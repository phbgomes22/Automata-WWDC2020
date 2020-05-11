//
//  Extensions.swift
//  BookCore
//
//  Created by Pedro Gomes on 11/05/20.
//


import BookCore
import SpriteKit
import GameplayKit
import UIKit
import PlaygroundSupport

public func edgeCircle(pos: CGPoint, at angle: CGFloat, radius: CGFloat) -> CGPoint {

    let newX = pos.x + (radius)*cos(angle)
    let newY = pos.y + (radius)*sin(angle)
    
    return CGPoint(x: newX, y: newY)
}


public struct Sound {
    
    public static var partialNotes = ["0b-b0", "2b-d1", "3b-e1", "4b-f1", "5b-g1", "6b-a1"]
    public static var lastRandom: Int = 0
    public static var lineNote = "8b-b1"
    
    public static func randomSound() -> String {
        var random = Int.random(in: 0...partialNotes.count - 1)
        while random == Sound.lastRandom {
            random = Int.random(in: 0...partialNotes.count - 1)
        }
        Sound.lastRandom = random
        let str = Sound.partialNotes[random] + ".wav"
        print(str)
        
        return str //SKAudioNode(fileNamed: str)
    }
    
}

public extension UIBezierPath {
    func addArrowBody(start: CGPoint, end: CGPoint, controlPoint: CGPoint) {
        self.move(to: start)
        
        let controlPoint = controlPoint
        
        self.addQuadCurve(to: end, controlPoint: controlPoint)
    }
    
    func addArrowHead(end: CGPoint, controlPoint: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        
        self.move(to: end)
        
        let controlPoint = controlPoint
        
        let startEndAngle = atan((end.y - controlPoint.y) / (end.x - controlPoint.x)) + ((end.x - controlPoint.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        self.addLine(to: arrowLine1)
        self.addLine(to: arrowLine2)
        self.close()
        
    }
}

public extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



