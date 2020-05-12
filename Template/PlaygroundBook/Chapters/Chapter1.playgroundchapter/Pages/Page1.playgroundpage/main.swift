/*:
__Cordel__ Literature is a traditional literary genre of Brazil. Its content is commonly written in __verses__ printed with __woodcut__ in small __leaflets__.



Welcome to the 🌵 **Cordel Roots**

When you're hooked you can not stop

Prepare your walking boots

**Shake your iPad to drop!**



 - Experiment:  Drop a cordel During the __morning__ ☀️ or at __night__ 🌙 to see some of the most common genres of cordels that brazilians read to __shake__ off the bad mood. **Run the code** to start!

*/

//#-hidden-code


import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore

public var answer = ""

public func add(element: String) {
    answer += element
}

public var chosenState: String = ""

public func startAt(state: String) {
    chosenState = state
}

public var A = "A"
public var B = "B"
public var N = "N"

public var 🎩 = "🎩"
public var 🐶 = "🐶"
public var 🤖 = "🤖"
public var 🔥 = "🔥"
public var 🎱 = "🎱"

//#-end-hidden-code

/*:
   Choose the state where you will start!
*/

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, A, B, N)
startAt(state: /*#-editable-code State*//*#-end-editable-code*/)
//#-code-completion(identifier, hide, A, B, N)


/*:
    Add elements to the State Machine!
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, add(element:))
//#-code-completion(identifier, show, 🎩, 🤖, 🐶, 🔥, 🎱)
//#-editable-code

//#-end-editable-code


//#-hidden-code

// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)

    scene.fsmString = answer

    scene.firstState = FSMLogic.StatesPG1.second

    if chosenState == "A" {
        scene.firstState = FSMLogic.StatesPG1.second
    } else if chosenState == "B" {
        scene.firstState = FSMLogic.StatesPG1.third
    } else if chosenState == "N" {
       scene.firstState = FSMLogic.StatesPG1.first
    }
   
}



PlaygroundPage.current.liveView = sceneView
/*
add(element: 🐶)
add(element: 🎱)
add(element: 🤖)
add(element: 🎱)
add(element: 🤖)
 */

//#-end-hidden-code
