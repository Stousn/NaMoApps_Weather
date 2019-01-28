//
//  CacheKeys.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Keys for in `UserDefaults.standard` cached API responses */
enum CacheKeys {
    /** Keys for in `UserDefaults.standard` cached API responses for `MainViewController` */
    enum main:String {
        case WEATHER_DATA_LOCATION
        case WEATHER_IMAGE_LOCATION
        case LAST_UPDATE_LOCATION
        case WEATHER_DATA_SEARCH
        case WEATHER_IMAGE_SEARCH
        case LAST_UPDATE_SEARCH
        enum settings:String {
            case ADAPTIVE_SIZE_SWITCH
            case DEFAULT_LOCATION
        }
        
    }
}
