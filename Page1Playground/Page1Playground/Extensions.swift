//
//  Extensions.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 11/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import Foundation
import SpriteKit

public func emojiToImage(text: String, size: CGFloat) -> UIImage {

    let outputImageSize = CGSize.init(width: size, height: size)
    let baseSize = text.boundingRect(with: CGSize(width: 2048, height: 2048),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
    let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
    let font = UIFont.systemFont(ofSize: fontSize)
    let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [.font: font], context: nil).size

    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    style.lineBreakMode = NSLineBreakMode.byClipping

    let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                 NSAttributedString.Key.paragraphStyle: style,
                                                 NSAttributedString.Key.backgroundColor: UIColor.clear ]

    UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
    text.draw(in: CGRect(x: (size - textSize.width) / 2,
                         y: (size - textSize.height) / 2,
                         width: textSize.width,
                         height: textSize.height),
                         withAttributes: attr)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

extension UIImage {
    func convertImageToBW() -> UIImage {

        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

        return UIImage(cgImage: cgImage!)
    }
    
    
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}


//
//
// MARK: - Extensions

public extension UIBezierPath {
    public func addArrowBody(start: CGPoint, end: CGPoint, controlPoint: CGPoint) {
        self.move(to: start)
        
        let controlPoint = controlPoint
        
        self.addQuadCurve(to: end, controlPoint: controlPoint)
    }
    
    public func addArrowHead(end: CGPoint, controlPoint: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        
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
    public convenience init(hexString: String) {
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

public func edgeCircle(pos: CGPoint, at angle: CGFloat, radius: CGFloat) -> CGPoint {

    let newX = pos.x + (radius)*cos(angle)
    let newY = pos.y + (radius)*sin(angle)
    
    return CGPoint(x: newX, y: newY)
}


public struct Sound {
    
    private static var partialNotes = ["0b-b0", "2b-d1", "3b-e1", "4b-f1", "5b-g1", "6b-a1"]
    private static var memorizeNotes = ["6b-a1", "7b-a1"]
    
    private static var lastRandom: Int = 0
    public static var lineNote = "8b-b1"
    public static var memorize: String = "6b-a1"
//    public static var memorize: String {
//        get {
//            let random = Int.random(in: 0...memorizeNotes.count - 1)
//            print(random, memorizeNotes[random])
//            return memorizeNotes[random]
//        }
//    }
    public static var lastMemorize: String = "8b-b1"
    
    public static func randomSound() -> String {
        var random = Int.random(in: 0...partialNotes.count - 1)
        while random == Sound.lastRandom {
            random = Int.random(in: 0...partialNotes.count - 1)
        }
        Sound.lastRandom = random
        let str = Sound.partialNotes[random] + ".wav"
        
        return str //SKAudioNode(fileNamed: str)
    }
    
    
    
}
