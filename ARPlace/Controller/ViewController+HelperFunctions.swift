//
//  ViewController+HelperFunctions.swift
//  ARPlace
//
//  Created by Isaac Raval on 05/14/2019
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreAudio
import AVFoundation

extension ViewController {
    //Create new bubble
    func newBubble() {
        
        guard let frame = self.sceneView.session.currentFrame else {
            return
        }
        let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
        
        let position = getNewPosition()
        let newBubble = soapBubble.clone()
        newBubble.position = position
        newBubble.scale = SCNVector3(1, 1, 1) * floatBetween(0.6, and: 1)
        
        // Move item around
        /*
        let firstAction = SCNAction.move(by: dir.normalized() * 0.5 + SCNVector3(0, 0.15, 0), duration: 0.5)
        firstAction.timingMode = .easeOut
        let secondAction = SCNAction.move(by: dir + SCNVector3(floatBetween(-1.5, and:1.5 ),floatBetween(0, and: 1.5),0), duration: TimeInterval(floatBetween(8, and: 11)))
        secondAction.timingMode = .easeOut
        newBubble.runAction(firstAction)
        
        // After x seconds, fade out and remove from scene
        newBubble.runAction(secondAction, completionHandler: {
            newBubble.runAction(SCNAction.fadeOut(duration: 5), completionHandler: {
                DispatchQueue.main.async {
                    //Can do something here
                }
                newBubble.removeFromParentNode()
            })
        }) */

        sceneView.scene.rootNode.addChildNode(newBubble)
    }
    
    //Setup for AR
    func initAR() {
        imageView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.size.height * 0.5, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.5))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "bubble_blower")
        imageView.alpha = 0.9
        self.sceneView.addSubview(imageView)
    }
    
    //Handle taps
    @objc func handleTap(_ recgnizer:UITapGestureRecognizer) {
        newBubble()
    }
    
    //Get new position
    func getNewPosition() -> (SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            return pos + SCNVector3(0, -0.07, 0) + dir.normalized() * 0.5
        }
        return SCNVector3(0, 0, -1)
    }
    
    //Called once per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = self.sceneView.session.currentFrame else {
            return
        }
        let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
        let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
        
        for node in sceneView.scene.rootNode.childNodes {
            node.look(at: pos)
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            break
        case .limited:
            break
        case .normal:
            ARTrackingIsReady = true
            break
        }
    }
    
    //Setup scene
    func setupScene() {
        self.initAR()
        self.sceneView.debugOptions = []
        self.arIsReady = true
    }
    
    //Notify that AR tracking is ready
    func notifyARTrackingIsReady() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "arTrackingReady"), object: nil)
    }
    
    //Handle view appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    //Handle view disappearing
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
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

// Random float between upper and lower bound (inclusive)
extension ViewController {
    private func floatBetween(_ first: Float,  and second: Float) -> Float {
        // Random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
}

// Extensions on standard library items and operator overloading
extension Array where Element: FloatingPoint {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func normalized() -> SCNVector3 {
        if self.length() == 0 {
            return self
        }
        
        return self / self.length()
    }
}
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func * (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

func / (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}
