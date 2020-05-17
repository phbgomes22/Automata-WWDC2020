/*:

 # Finite State Machines (FSM) 🤖!
 
 
 "**Finite State Machines**", what a daunting name! But don't be misled by it. FSM are are very fun to toy with, and are commonly used to model all sorts of behaviors.
 
 
  They work as such: starting from the initial **State**, the FSM will choose the next State it will **transition to** according to the **input** it receives.
 
 __States__ are usually represented by circles. They can have an output, that we will represent by the symbol on its side. A FSM can only be in one State at a time.
 
 ![State](smallerState.png)
 
 Transition between states are triggered by a certain inputs, and are represented by __lines__. The input will be defined by emojis. For exemple, the transition bellow would move you to another **State** when the FSM receives a 🔥.
 
 
 ![Line](linePage1.png)
 
 Each **input** will lead to **one** change of State, but only if the current State has a **transition** that is triggered by that **input**.


 * Experiment:
 Let's start! Try to use the FSM outputs to write the word "BANANA" 🍌🐵
 

 **First**, choose the state in which the FSM will start!
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

public var answer = ""

/// Adds an emoji as an input to the FSM!
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



// CODIGO FERRAZ
remoteView.send(.array([.string(answer), .string(chosenState)]))
// CODIGO FERRAZ

/*
add(input: 🐶)
add(input: 🎱)
add(input: 🤖)
add(input: 🎱)
add(input: 🤖)
 

 */

//#-end-hidden-code
