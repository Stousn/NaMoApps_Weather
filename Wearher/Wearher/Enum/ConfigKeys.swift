//
//  Config.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Keys of properties from `Config.plist`*/
enum ConfigKeys:String {

    /** Key for weather API image base URL */
    case API_IMG_BASE_URL

    /** Key for weather API base URL */
    case API_BASE_URL

    /** Key for weather API key */
    case API_KEY

    /** Key for debug setting */
    case DEBUG
}
