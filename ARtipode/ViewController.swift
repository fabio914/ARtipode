//
//  ViewController.swift
//  ARtipode
//
//  Created by Fabio Dela Antonio on 23/05/2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    let latitude: CGFloat = 53.3498
    let longitude: CGFloat = -6.2603

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Earth.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene

        // Earth's texture from https://commons.wikimedia.org/wiki/File:Solarsystemscope_texture_8k_earth_daymap.jpg

        if let earthNode = scene.rootNode.childNode(withName: "earth", recursively: false) {
            earthNode.runAction(SCNAction.rotate(by: -longitude * .pi/180.0, around: SCNVector3(0, 1, 0), duration: 0))
            earthNode.runAction(SCNAction.rotate(by: (-(90.0 - latitude)) * .pi/180.0, around: SCNVector3(1, 0, 0), duration: 0))
        }

        sceneView.pointOfView?.camera?.zFar = 15000.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.worldAlignment = .gravityAndHeading

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
