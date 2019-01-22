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

class AnimationService {
    
    init() {
    }
    
    func fadeViewIn(view : UIView, animationDuration: Double) {
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        })
    }
    
    func fadeViewOut(view : UIView, animationDuration: Double) {
        // Fade out the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 0
        })
        
    }
    
}
