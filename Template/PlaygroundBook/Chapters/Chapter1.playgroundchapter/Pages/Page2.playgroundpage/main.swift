/*:

*/


import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore


// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene2(fileNamed: "GameScene2") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
   
}



PlaygroundPage.current.liveView = sceneView

