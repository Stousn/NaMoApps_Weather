//
//  WeatherError.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

extension String: Error {}

/** Errors from Weather App*/
enum LocationError: Error {

    /** ERROR: Location could not be retrieved  */
    case getLocationFailed(message:String)
}
