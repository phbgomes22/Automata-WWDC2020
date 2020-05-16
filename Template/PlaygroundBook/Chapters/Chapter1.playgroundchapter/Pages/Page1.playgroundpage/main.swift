/*:

 # Welcome to State Machine 🤖!
 
 
 "**Finite State Machines**" (FSM) is a daunting name. But don't be misled by it. They are not , and very fun!
 
 FSM are commonly used, and they model all sorts of behaviors.
 
 Their __States__ are usually represented by circles. They can have output, that we will represent by the symbol on its side.
 
 ![State](smallerState.png)
 
Transition between states are triggered by a certain inputs, and are represented by __lines__. The input will be defined by an emoji, such as bellow.
 
 ![Line](linePage1.png)
 


 * Experiment:
 Let's start! Try to use the FSM to writte the word "BANANA" 🍌🐵
 

 **First**, choose the state in which the FSM will start!
*/

//#-hidden-code


import SpriteKit
import PlaygroundSupport
import UIKit
import BookAPI
import BookCore

public var answer = ""

public func add(input: String) {
    answer += input
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

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, A, B, N)
startAt(state: /*#-editable-code State*/A/*#-end-editable-code*/)
//#-code-completion(identifier, hide, A, B, N)


/*:
 
**Now**, add the inputs to for the State Machine!
 

 * Experiment:
 Add the emojis using the `add(input:)` function!
 */

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, add(input:))
//#-code-completion(identifier, show, 🎩, 🤖, 🐶, 🔥, 🎱)
//#-editable-code
// 🎩, 🐶, 🤖, 🔥, 🎱
add(input: 🎱)
add(input: 🔥)

//#-end-editable-code


//#-hidden-code

// Load the SKScene from 'GameScene.sks'

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 880))
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
add(input: 🐶)
add(input: 🎱)
add(input: 🤖)
add(input: 🎱)
add(input: 🤖)
 

 PlaygroundPage.current.assessmentStatus = .pass(message: " **Great!** When you're ready, go to the [**Next Page**](@next)!")
 */

//#-end-hidden-code
