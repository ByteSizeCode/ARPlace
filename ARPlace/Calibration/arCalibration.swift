//
//  arCalibration.swift
//  ARPlace
//
//  Created by Isaac Raval on 05/14/2019
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import AVFoundation

class arCalibration: UIView {
    
    //Properties
    var containerView:UIView?
    var phoneImage:UIImageView?
    var guideImage:UIImageView?
    var heading:UILabel?
    var subHeading:UILabel?
    var imageViewsFrame:CGRect?
    var calibrationDone: ((Bool) -> Void)?
    var isHorizontal:Bool = false
    var isTrackingReady:Bool = false

    //Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startAnimation(){
        stages = .holdVertical
    }
    
    
    //Handle calibration stages
    public var stages:AnimStages = .none {
        didSet {
            handleCalibrationStages()
    }
   
}
}
