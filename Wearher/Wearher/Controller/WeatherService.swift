//
//  WeatherController.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

/** Singelton of class `WeatherService`*/
let weatherService = WeatherService()

/** provides weather data and queries API */
class WeatherService {
    
    private let WATHER_SEARCH_QUERY:String = "weather?q="
    
     private let WATHER_LOCATION_QUERY:String = "weather?"
    
    private let apiQuerry:String?
    
    init() {
        self.apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
    }
    
    /** returns location based weather data */
    func loadWeatherDataFromLocation() throws -> ApiModel {
        print(locationService)
        guard nil != locationService.locationQuery  else {
            throw WeatherError.apiCall(message: "Error during loadWeatherDataFromLocation: locationService.locationQuery was nil")
        }
        do {
            let url:URL = try self.urlResolver(query: self.WATHER_LOCATION_QUERY + locationService.locationQuery!)
            if configsService.getDebug() {
                print("DEBUG: \(url)")
            }
            return try self.callWeatherApiAndCacheResult(url: url, cacheKey: CacheKeys.main.WEATHER_DATA_LOCATION.rawValue, cacheUpdateKey: CacheKeys.main.LAST_UPDATE_LOCATION.rawValue)
            
        } catch let e {
            print("ERROR: \(e)")
            throw WeatherError.apiCall(message: "Error during calling weather api: \(e)")
        }
        
    }
    
    /** returns text search based weather data */
    func loadWeatherDataFromSearch(search:String) throws -> ApiModel {
        do {
            let url:URL = try self.urlResolver(query: self.WATHER_SEARCH_QUERY + search)
            if configsService.getDebug() {
                print("DEBUG: \(url)")
            }
            return try self.callWeatherApiAndCacheResult(url: url, cacheKey: CacheKeys.main.WEATHER_DATA_SEARCH.rawValue, cacheUpdateKey: CacheKeys.main.LAST_UPDATE_SEARCH.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw WeatherError.apiCall(message: "Error during calling weather api: \(e)")
        }
    }
    
    /** loads location based weather data stored by CacheService */
    func loadCachedWeatherDataFromLocation() throws -> ApiModel {
        do {
            let weather:Data = try cacheService.getCachedData(key: CacheKeys.main.WEATHER_DATA_LOCATION.rawValue)
            let welcome:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: weather)
            return welcome
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** loads search based weather data stored by CacheService */
    func loadCachedWeatherDataFromSearch() throws -> ApiModel {
        do {
            let weather:Data = try cacheService.getCachedData(key: CacheKeys.main.WEATHER_DATA_SEARCH.rawValue)
            let welcome:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: weather)
            return welcome
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** loads location based weather image stored by CacheService */
    func loadCachedWeatherImgFromLocation() throws -> Data {
        do {
            return try cacheService.getCachedData(key: CacheKeys.main.WEATHER_IMAGE_LOCATION.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** loads search based weather image stored by CacheService */
    func loadCachedWeatherImgFromSearch() throws -> Data {
        do {
            return try cacheService.getCachedData(key: CacheKeys.main.WEATHER_IMAGE_SEARCH.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** loads location based timestamp of last weather data change stored by CacheService */
    func loadCachedLastWeatherUpdateFromLocation() throws -> String {
        do {
            return try cacheService.getCachedString(key: CacheKeys.main.LAST_UPDATE_LOCATION.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** loads search based timestamp of last weather data change stored by CacheService */
    func loadCachedLastWeatherUpdateFromSearch() throws -> String {
        do {
            return try cacheService.getCachedString(key: CacheKeys.main.LAST_UPDATE_SEARCH.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** queries weather API and persists result with CacheService */
    private func callWeatherApiAndCacheResult(url:URL, cacheKey:String, cacheUpdateKey:String) throws -> ApiModel {
        let data = try Data(contentsOf: url)
        if configsService.getDebug() {
            print("DEBUG: Load Weather Data from Network: \(data)")
        }
        
        cacheService.cacheData(key: cacheKey, data: data)
        cacheService.cacheString(key: cacheUpdateKey, str: getTimestamp())
        
        let response:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
        return response
    }
    
    /** resolves API url */
    private func urlResolver (query:String) throws -> URL {
        if apiQuerry == nil {
            throw WeatherError.urlResolver(message: "apiQuerry was nil")
        }
        return URL(string: configsService.getApiBaseUrl() +  query + apiQuerry!)!
    }
}
