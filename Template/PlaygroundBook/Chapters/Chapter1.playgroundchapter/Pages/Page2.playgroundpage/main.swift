/*:

 # Becoming the Machine 🤖!
 
 Now, let's **swich places** in a Memory Game!
 
 **Memorize** the sequence of inputs given. They will be either purple 🟣 or white ⚪️. Then, the initial state will be chosen.
 
 After that, starting at the **initial state**, touch on **every State** you transition to until you go through all the input sequence.
 If you touch all in the right order, you win 🏆!
 
 - Note:
  This game works because of the **deterministic** property of this FSM. That means that if start at a given **initial State**, if we run the **same input sequence**, we will always arrive at the same **final State**.
 
 * Experiment:
 Let's start! Choose the number of inputs that you will try to memorize!
 
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
 
  - Tip:
  If you chose to memorize 3 inputs, you'll need to move through 4 States, the initial one and three others based on the input you were given!
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
