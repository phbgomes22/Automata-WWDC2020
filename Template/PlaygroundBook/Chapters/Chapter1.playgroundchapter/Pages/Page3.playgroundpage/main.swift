/*:

 # Wielding the FSM Power 🤖!
 
 A common application for FSM are **games**! They can be used to model how enemies will act, how the game mode will change, and even dialogues!
 
 
 **Now**, try that out ourselves!
 
 
 * Experiment:
 In this game, each phase is represented by a State, and we move to the next State when the ball hits its target.
 We can define what changes between phases by adding functions bellow!

*/

//#-hidden-code
import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore



// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
let scene = GameScene3(fileNamed: "GameScene3")!
scene.scaleMode = .aspectFill
// Present the scene

public func stopOrbs() {
    scene.stopOrbs()
}

public func circleFaster() {
    if (scene.durationBallMove - 5.5 > 3.0) {
        scene.durationBallMove -= 5.5
    } else {
        scene.durationBallMove = 3.0
    }
}

public func launchSlower() {
    if (scene.durationBallMove - 0.3 > 0.25) {
        scene.speedBallMovement -= 0.3
    } else {
        scene.speedBallMovement = 0.3
    }
}

public func hideAim() {
    scene.isAimHidden = true
}

public var isBlinking: Bool = false

public func blinkTarget() {
    if(!isBlinking) {
        scene.blinkTarget()
        isBlinking = true
    }
}
public func invertDirection() {
    scene.ballClockwise.toggle()
}

public func state2() {
    
//#-end-hidden-code
/*:
 * Callout(State 2!):
 Add the changes that will happen when we go to State 2!
 You can make the game easier, or harder!
*/
// add your code to State 2 here!
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, circleFaster(), launchSlower(), hideAim(), blinkTarget(), invertDirection())
//#-editable-code

//#-end-editable-code

/*:
 * Callout(State 3!):
 Add the changes that will happen when we reach State 3!
     
*/
//#-hidden-code
}


func state3() {
    
//#-end-hidden-code
// add your code to State 3 here!
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, circleFaster(), launchSlower(), hideAim(), blinkTarget(), invertDirection(), stopOrbs())
//#-editable-code

//#-end-editable-code
/*:
 * Experiment:
 To try other combinations, change the functions and run the code again!
     
 */
//#-hidden-code
}


scene.functionState2 = state2
scene.functionState3 = state3


sceneView.presentScene(scene)

PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code

