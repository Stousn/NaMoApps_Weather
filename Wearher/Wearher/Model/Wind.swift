//
//  WindModel.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    
    var description: String {
        return "wind speed: \(speed);"
    }
}
