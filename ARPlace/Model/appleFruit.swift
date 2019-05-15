//
//  appleFruit.swift
//  ARPlace
//
//  Created by Isaac Raval on 05/14/2019
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import Foundation
import ARKit

class appleFruit: SCNNode {
    
    override init() {
        super.init()
        let bubble = SCNPlane(width: 0.25, height: 0.25)
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "apple")
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        material.blendMode = .screen
        bubble.materials = [material]
        self.geometry = bubble
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
