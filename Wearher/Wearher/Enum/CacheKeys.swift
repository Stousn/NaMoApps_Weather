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
        case WEATHER_DATA
        case WEATHER_IMAGE
        case LAST_UPDATE
    }
}
