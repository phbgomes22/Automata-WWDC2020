/*:
Pagina 2
*/


//#-hidden-code
import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore


//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(literal, show, integer)
//#-code-completion(identifier, show, 3, 5, 7, 9, 11)
var movesToMemorize: Int = /*#-editable-code number of moves*/3/*#-end-editable-code*/


//#-hidden-code
// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
if let scene = GameScene2(fileNamed: "GameScene2") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    scene.numberOfMoves = movesToMemorize
    // Present the scene
    sceneView.presentScene(scene)
   
}



PlaygroundPage.current.liveView = sceneView


//#-end-hidden-code
