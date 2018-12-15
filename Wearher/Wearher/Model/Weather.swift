//
//  WeatherModel.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
