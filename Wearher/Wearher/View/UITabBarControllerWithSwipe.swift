//
//  UITabBarControllerWithSwipe.swift
//  Wearher
//
//  Created by Stefan Reip on 15.12.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

class UITabBarControllerWithSwipe: UITabBarController {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let fromView = tabBarController.selectedViewController?.view,
            let toView = viewController.view, fromView != toView,
            let controllerIndex = self.viewControllers?.index(of: viewController) {
            
            let viewSize = fromView.frame
            let scrollRight = controllerIndex > tabBarController.selectedIndex
            
            // Avoid UI issues when switching tabs fast
            if fromView.superview?.subviews.contains(toView) == true { return false }
            
            fromView.superview?.addSubview(toView)
            
            let screenWidth = UIScreen.main.bounds.size.width
            toView.frame = CGRect(x: (scrollRight ? screenWidth : -screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
            
            UIView.animate(withDuration: 0.25, delay: TimeInterval(0.0), options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
                fromView.frame = CGRect(x: (scrollRight ? -screenWidth : screenWidth), y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
                toView.frame = CGRect(x: 0, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
            }, completion: { finished in
                if finished {
                    fromView.removeFromSuperview()
                    tabBarController.selectedIndex = controllerIndex
                }
            })
            return true
        }
        return false
    }
}
