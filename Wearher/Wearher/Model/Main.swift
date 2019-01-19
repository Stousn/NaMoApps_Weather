//
//  MainModel.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

struct Main: Codable {
    let temp, tempMin, tempMax, pressure, humidity: Double

    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    var description: String {
        return "Temperature: \(temp) degrees;"
    }
}
