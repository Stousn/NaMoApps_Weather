//
//  ColorService.swift
//  Wearher
//
//  Created by Stefan Reip on 24.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation
import UIKit

/** Singelton of class `ColorService`*/
let colorService = ColorService()

/** Color calculation and time specific color gradients */
class ColorService {
    //let colorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    //let colorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    
    let gl: CAGradientLayer
    
    init() {
        self.gl = CAGradientLayer()
        self.gl.colors = getColorsForTime()
        self.gl.locations = [0.0, 1.0]
    }
    
    /** returns a color gradient for the specific day time */
    func getColorsForTime() -> [CGColor] {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 23,0,1,2,3:
            return [
                UIColor(red:0.63, green:0.67, blue:0.81, alpha:1.0).cgColor,
                UIColor(red:0.63, green:0.67, blue:0.81, alpha:0.8).cgColor
            ]
        case 4,5:
            return [
                UIColor(red:0.65, green:0.71, blue:0.95, alpha:1.0).cgColor,
                UIColor(red:0.82, green:0.65, blue:0.95, alpha:1.0).cgColor
            ]
        case 6,7,8:
            return [
                UIColor(red:0.62, green:0.76, blue:0.93, alpha:1.0).cgColor,
                UIColor(red:0.68, green:0.62, blue:0.93, alpha:1.0).cgColor
            ]
        case 9,10,11:
            return [
                UIColor(red:0.62, green:0.85, blue:0.93, alpha:0.8).cgColor,
                UIColor(red:0.62, green:0.85, blue:0.93, alpha:1.0).cgColor
            ]
        case 12,13,14,15:
            return [
                UIColor(red:0.62, green:0.78, blue:0.93, alpha:0.8).cgColor,
                UIColor(red:0.62, green:0.78, blue:0.93, alpha:1.0).cgColor
            ]
        case 16,17,18:
            return [
                UIColor(red:0.62, green:0.72, blue:0.93, alpha:1.0).cgColor,
                UIColor(red:0.83, green:0.62, blue:0.93, alpha:1.0).cgColor
            ]
        default:
            return [
                UIColor(red:0.55, green:0.55, blue:0.84, alpha:1.0).cgColor,
                UIColor(red:0.55, green:0.55, blue:0.84, alpha:0.8).cgColor
            ]
        }
    }
    
}
