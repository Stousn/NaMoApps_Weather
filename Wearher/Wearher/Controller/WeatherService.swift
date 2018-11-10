//
//  WeatherController.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

let weatherService = WeatherService()

class WeatherService {
    
    private let WATHER_QUERY:String = "weather?q="
    
    private let apiQuerry:String?
    
    init() {
        self.apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
    }
    
    func loadWeatherDataFromLocation() {
        // TODO: Implement
    }
    
    func loadWeatherDataFromSearch(search:String) throws -> ApiModel {
        do {
            let url:URL = try self.urlResolver(query: self.WATHER_QUERY + search)
            if configsService.getDebug() {
                print("DEBUG: \(url)")
            }
            return try self.callWeatherApiAndCacheResult(url: url, cacheKey: CacheKeys.main.WEATHER_DATA.rawValue, cacheUpdateKey: CacheKeys.main.LAST_UPDATE.rawValue)
        } catch let e {
            print("ERROR: \(e)")
            throw WeatherError.apiCall(message: "Error during calling weather api: \(e)")
        }
    }
    
    func loadCachedWeatherDataFromLocation() {
        // TODO: Implement
    }
    
    func loadCachedWeatherDataFromSearch() {
        // TODO: Implement
    }
    
    func loadCachedWeatherImg() {
        // TODO: Implement
    }
    
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
    
    private func urlResolver (query:String) throws -> URL {
        guard apiQuerry == nil else {
            return URL(string: configsService.getApiBaseUrl() +  query + apiQuerry!)!
        }
        throw WeatherError.urlResolver(message: "apiQuerry was nil")
    }
}
