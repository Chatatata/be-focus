//
//  Extensions.swift
//  be #focused
//
//  Created by Efe Helvaci on 19.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit

extension UIView {
    func rotateTimes(duration: CFTimeInterval = 0.6, times: Double = 1.0, completionDelegate: AnyObject? = nil) {
        let roundTimes = times * 2
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * roundTimes)
        rotateAnimation.duration = duration
        
        if let delegate = completionDelegate as? CAAnimationDelegate{
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
