//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Stefan Reip on 31.01.19.
//  Copyright © 2019 Stefan Reip. All rights reserved.
//

import XCTest

@testable import Weather


class WeatherTests: XCTestCase {
    
    var weatherService:WeatherService?
    
    var colorService:ColorService?
    
    var cacheService:CacheService?
    
    let LOCATION:String = "Leoben,AT"
    
    let TEST_KEY:String = "TEST_WEATHER_DATA_CACHE_KEY"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        weatherService = WeatherService()
        colorService = ColorService()
        cacheService = CacheService()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cacheService!.clearCache()
    }
    
    func testGetWeatherData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        do {
            let result:ApiModel =  try weatherService!.loadWeatherDataFromSearch(search: LOCATION)
            XCTAssert(result.main.temp < 100.0 && result.main.temp > -100.0)
            XCTAssert(result.main.description != "")
            XCTAssert(result.name.starts(with: "Leoben"))
        } catch let e {
            print("ERROR: \(e)")
            XCTFail()
        }
    }
    
    func testGetWeatherDataCache() {
        do {
            let input:ApiModel =  try weatherService!.loadWeatherDataFromSearch(search: LOCATION)
            
            let cacheOutput:Data = (try cacheService?.getCachedData(key: CacheKeys.main.WEATHER_DATA_SEARCH.rawValue))!
            let result:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: cacheOutput)
            
            XCTAssert(result.description == input.description)
            XCTAssert(result.main.temp == input.main.temp)
            XCTAssert(result.name == input.name)
        } catch let e {
            print("ERROR: \(e)")
            XCTFail()
        }
    }
    
    func testPerformanceCache() {
        
        // This is an example of a performance test case.
        self.measure {
            loadDataIntoCache()
            loadDataFromCache()
        }
    }
    
    func loadDataIntoCache() {
        cacheService?.cacheString(key: TEST_KEY, str: TEST_KEY)
    }
    
    func loadDataFromCache() {
        do {
            let _ = try cacheService?.getCachedString(key: TEST_KEY)
        } catch let e {
            print("ERROR: \(e)")
            XCTFail()
        }
    }
    
}
