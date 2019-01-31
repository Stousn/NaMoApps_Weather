//
//  Coord.swift
//  Weather
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

struct Coord: Codable {
    let lon, lat: Double
    
    public var description: String { return "Coord[lat: \(lat), lon: \(lon)]" }
}
