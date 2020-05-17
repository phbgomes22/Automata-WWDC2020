/*:

 # Becoming the Machine 🤖!
 
 Now, let's **swich places** in a Memory Game!
 
 **Memorize** the sequence of inputs given. They will be either purple 🟣 or white ⚪️. Then, the initial state will be chosen.
 
 After that, starting at the **initial state**, touch **every State** you transition to until you go through all the input sequence.
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


// *** LIVE VIEW CODE

class MessageHandler: PlaygroundRemoteLiveViewProxyDelegate {

    func remoteLiveViewProxy(
        _ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
        received message: PlaygroundValue
    ) {
        print("Received a message from the always-on live view", message)
    }

    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {}
}

guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}

let handler = MessageHandler()
remoteView.delegate = handler

// *** LIVE VIEW CODE


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
remoteView.send(.integer(movesToMemorize))

//#-end-hidden-code
