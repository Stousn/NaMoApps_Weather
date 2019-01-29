//
//  WeatherError.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Errors from Weather App*/
enum WeatherError: Error {

    /** ERROR: Cache was empty for key */
    case emptyCache(message:String)

    /** ERROR: Could not resolve url */
    case urlResolver(message:String)

    /** ERROR: Weather API call failed */
    case apiCall(message:String)
}
