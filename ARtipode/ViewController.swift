//
//  ViewController.swift
//  ARtipode
//
//  Created by Fabio Dela Antonio on 23/05/2022.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet private var sceneView: ARSCNView!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Earth.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene

        updateCoordinates(latitude: 0, longitude: 0)
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

    private func updateCoordinates(latitude: Float, longitude: Float) {
        let scene = sceneView.scene

        guard let earthNode = scene.rootNode.childNode(withName: "earth", recursively: false),
            let earthRadius = (earthNode.geometry as? SCNSphere)?.radius
        else {
            return
        }

        let longitudeRotation = SCNMatrix4Rotate(SCNMatrix4Identity, -longitude * .pi/180.0, 0, 1, 0)
        let latitudeRotation = SCNMatrix4Rotate(longitudeRotation, (-(90.0 - latitude)) * .pi/180.0, 1, 0, 0)
        let translation = SCNMatrix4Translate(latitudeRotation, 0, -(Float(earthRadius) + 1), 0)
        earthNode.transform = translation

        sceneView.pointOfView?.camera?.zFar = 2.5 * earthRadius
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

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        updateCoordinates(
            latitude: Float(firstLocation.coordinate.latitude),
            longitude: Float(firstLocation.coordinate.longitude)
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get location: \(error)")
    }
}
