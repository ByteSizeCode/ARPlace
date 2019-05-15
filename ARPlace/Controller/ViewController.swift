//
//  ViewController.swift
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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //Properties
    var imageView:UIImageView!
    @IBOutlet var sceneView: ARSCNView!
    let soapBubble = appleFruit()
    var averageBackgroundNoise:Float?
    var arIsReady = false
    var bubblesLeft = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
        //Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        //Calibrate
        let calibrationView = arCalibration(frame:self.view.bounds)
        self.view.addSubview(calibrationView)
        calibrationView.calibrationDone = {  [weak self] done in
            if done {
                self?.setupScene()
            }
        }
    }
    
    //Notify when AR tracking is ready
    var ARTrackingIsReady:Bool = false {
        didSet{
            notifyARTrackingIsReady()
        }
    }
}
