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

/** Loads and stores all sort of values in `UserDefaults.standard` */
class CacheService {
    
    private let SHARED_PREFS = UserDefaults.standard
    
    init() {
        
    }
    
    /** Saves `data` in `UserDefaults.standard` */
    func cacheData(key:String, data:Data) {
        if configsService.getDebug() {
            print("DEBUG: Chaching data for \(key): \(data)")
        }
        SHARED_PREFS.setValue(data, forKey: key)
    }
    
    /** Saves a string (`str`) in `UserDefaults.standard` */
    func cacheString(key:String, str:String) {
        SHARED_PREFS.setValue(str, forKey: key)
    }
    
    /** Saves a bool in `UserDefaults.standard` */
    func cacheBool(key:String, bool:Bool) {
        SHARED_PREFS.setValue(bool, forKey: key)
    }
    
    /** Loads data for `key` from `UserDefaults.standard`. 
      * Throws error if no `data` are stored. 
      */
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
    
    /** Loads string for `key` from `UserDefaults.standard`. 
      * Throws error if no `data` are stored. 
      */
    func getCachedString(key:String) throws -> String {
        if let str = SHARED_PREFS.string(forKey: key) {
            return str
        } else {
            throw WeatherError.emptyCache(message: "Error loading value for key \(key) from cache")
        }
    }
    
    /** Loads bool for `key` from `UserDefaults.standard`. 
      * returns false if no value is stored. 
      */
    func getCachedBool(key:String) -> Bool {
        return SHARED_PREFS.bool(forKey: key)
    }
    
    /** Clears all stored values in `UserDefaults.standard`. */
    func clearCache() {
        let dictionary = SHARED_PREFS.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            SHARED_PREFS.removeObject(forKey: key)
        }
    }
}
