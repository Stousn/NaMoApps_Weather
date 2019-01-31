//
//  CacheKeys.swift
//  Weather
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Keys for CacheService to load and store `UserDefaults.standard` values */
enum CacheKeys {

    /** Keys for Weather API and User Settings */
    enum main:String {

        /** Cache key for location based weather api data results */
        case WEATHER_DATA_LOCATION

        /** Cache key for location based weather api image results */
        case WEATHER_IMAGE_LOCATION

        /** Cache key for timestamp of last location based weather api call */
        case LAST_UPDATE_LOCATION

        /** Cache key for search based weather api data results */
        case WEATHER_DATA_SEARCH

        /** Cache key for search based weather api image results */
        case WEATHER_IMAGE_SEARCH

        /** Cache key for timestamp of last search based weather api call */
        case LAST_UPDATE_SEARCH

        /** Cache key for user settings*/
        enum settings:String {

            /** Cache key for user setting of adaptive content size */
            case ADAPTIVE_SIZE_SWITCH

            /** Cache key for user setting of default value for search based weather api calls*/
            case DEFAULT_LOCATION
        }
        
    }
}
