/*:

 # Becoming the Machine 🤖!
 
 Now, let's **swich places**!
 
 A sequence of inputs, either purple 🟣 or white ⚪️, will be drawn. Then, the initial state will be chosen.
 Touch the States as you move to them, until you cover all the input.
 
 
 - Note:
 We can only play this game because of a property of this FSM: it is **deterministic**. That means that if we are at a given **initial State**, if we run the **same input sequence**, we will always arrive at the same **final State**.


 
 * Experiment:
 Let's start! Choose a number of inputs that you will try to memorize!
 

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
var movesToMemorize: Int = /*#-editable-code number of moves*/4/*#-end-editable-code*/

/*:
 
 When you're ready, run the code!
 
 A sequence of size  `movesToMemorize`  will be drawn. Then, the initial state will be chosen. Follow the path from it!
 
  - Tip:
  If you choose to memorize 3 inputs, you'll need to move through 3 States.
*/

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
