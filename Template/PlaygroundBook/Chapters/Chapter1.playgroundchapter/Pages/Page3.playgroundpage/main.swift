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
    if (scene.durationBallMove - 0.35 > 0.1) {
        scene.speedBallMovement -= 0.35
    } else {
        scene.speedBallMovement = 0.1
    }
}

public func hideAim() {
    scene.isAimHidden = true
}

public isBlinking: Bool = false

public func blinkTarget() {
    if(!isBlinking) {
        scene.blinkTarget()
        isBlinking = true
    }
}

public func state2() {
    
    // first user code will enter here!
    circleFaster()
    blinkTarget()
}


public func state3() {
    // second user code will enter here!
}

scene.functionState2 = state2
scene.functionState3 = state3


sceneView.presentScene(scene)




PlaygroundPage.current.liveView = sceneView


