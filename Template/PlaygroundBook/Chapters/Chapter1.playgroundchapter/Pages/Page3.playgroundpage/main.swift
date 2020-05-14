/*:
Pagina 3
*/


import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore




// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
if let scene = GameScene3(fileNamed: "GameScene3") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    // Present the scene
    sceneView.presentScene(scene)
   
}



PlaygroundPage.current.liveView = sceneView


