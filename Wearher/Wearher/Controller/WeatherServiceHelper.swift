//
//  WeatherServiceHelper.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Returns the current timestamp as `String` in Format __d.M HH:mm__*/
func getTimestamp() -> String {
    let date = Date();
    let formatter = DateFormatter();
    formatter.dateFormat = "d.M HH:mm";
    // formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}
