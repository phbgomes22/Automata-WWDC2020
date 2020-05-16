//
//  GameViewController.swift
//  Page1Playground
//
//  Created by Pedro Gomes on 06/05/20.
//  Copyright © 2020 Pedro Gomes. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
        if let scene = GameScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            sceneView.presentScene(scene)
        }
        
        self.view = sceneView
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
