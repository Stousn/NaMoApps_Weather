//
//  AnimationService.swift
//  Wearher
//
//  Created by Stefan Reip on 24.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation
import UIKit

/** Singelton of class `AnimationService`*/
let animationService = AnimationService()

/** Animation and visual effects */
class AnimationService {
    
    init() {
    }
    
    /** Fades in view to alpha=1 for animationDuration */
    func fadeViewIn(view : UIView, animationDuration: Double) {
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        })
    }
    
    /** Fades out view to alpha=0 for animationDuration */
    func fadeViewOut(view : UIView, animationDuration: Double) {
        // Fade out the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 0
        })
        
    }
    
}
