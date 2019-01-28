//
//  CacheService.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Singelton of class `CacheService`*/
let cacheService = CacheService()

class CacheService {
    
    private let SHARED_PREFS = UserDefaults.standard
    
    init() {
        
    }
    
    func cacheData(key:String, data:Data) {
        if configsService.getDebug() {
            print("DEBUG: Chaching data for \(key): \(data)")
        }
        SHARED_PREFS.setValue(data, forKey: key)
    }
    
    func cacheString(key:String, str:String) {
        SHARED_PREFS.setValue(str, forKey: key)
    }
    
    func cacheBool(key:String, bool:Bool) {
        SHARED_PREFS.setValue(bool, forKey: key)
    }
    
    func getCachedData(key:String) throws -> Data {
        if let data = SHARED_PREFS.data(forKey: key) {
            if configsService.getDebug() {
                print("DEBUG: Load cached Data for \(key): \(data)")
            }
            return data
        } else {
            throw WeatherError.emptyCache(message: "Error loading value for key \(key) from cache")
        }
    }
    
    func getCachedString(key:String) throws -> String {
        if let str = SHARED_PREFS.string(forKey: key) {
            return str
        } else {
            throw WeatherError.emptyCache(message: "Error loading value for key \(key) from cache")
        }
    }
    
    func getCachedBool(key:String) -> Bool {
        return SHARED_PREFS.bool(forKey: key)
    }
    
    func clearCache() {
        let dictionary = SHARED_PREFS.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            SHARED_PREFS.removeObject(forKey: key)
        }
    }
}
