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
enum WeatherError: Error {
    case emptyCache(message:String)
    case urlResolver(message:String)
    case apiCall(message:String)
}
