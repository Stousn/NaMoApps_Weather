//
//  FirstViewController.swift
//  Weather
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation
import CoreMotion

/** First view that is loaded on start-up
 *  loads weather data for gps location
 *  result can be shared
 *  swipe down for update
 *  calculated ui color for date time
 *  increases and decreases size of texts when moved up or down (if enabled)
 */
class MainViewController: SwipableTabViewController {
    
    let SHARED_PREFS = UserDefaults.standard
    
    let WATHER_QUERY:String = "weather?q="

    var apiQuerry:String?

    /** Big current degrees shown top right */
    @IBOutlet weak var degrees: UILabel!
   
    /** Main weather condition shown below city name */
    @IBOutlet weak var conditions: UILabel!
    
    /** Name of GPS detected city (where the weather data belongs to) */
    @IBOutlet weak var weatherLocationName: UILabel!
    
    /** Low res image of current weather condition provided by the api */
    @IBOutlet weak var weatherIcon: UIImageView!
    
    /** Timestamp of last weather update */
    @IBOutlet weak var lastUpdate: UILabel!
    
    // Unused. `onScreenSwipeDown` is the new impl
    // @IBOutlet var screenEdgePanGestureDown: UIScreenEdgePanGestureRecognizer!
    
    
    /** Called on first load of view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the colors
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
        
        apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
        
        // Load weather data syncronously from cache and check current location
        loadCachedWeatherDataAndUpdateView()
        locationService.getCurrentLocation()
        
        // Register swipe down update gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(screenSwipedDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        // Load weather data asynchronously from the api -> 2 secs. interval for location detection
        loadAsyncWeatherData()
        
        
        // Observe and trigger motion based ui size updates
        NotificationCenter.default.addObserver(self, selector: #selector(increaseSize(_:)), name: Notification.Name(rawValue: "increaseSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(decreaseSize(_:)), name: Notification.Name(rawValue: "decreaseSize"), object: nil)
        
        if cacheService.getCachedBool(key: CacheKeys.main.settings.ADAPTIVE_SIZE_SWITCH.rawValue) {
            motionService.coreMotion()
        }
        
    }
    
    /** Called when the view is appearing (again) */
    override func viewDidAppear(_ animated: Bool) {
        
        // Update colors
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
        
        
        // Check and call motion based ui size updates
        if cacheService.getCachedBool(key: CacheKeys.main.settings.ADAPTIVE_SIZE_SWITCH.rawValue) {
            motionService.coreMotion()
        }
    }
    
    /** Calles when the view will disappear */
    override func viewWillDisappear(_ animated: Bool) {
        // stop motion triggering
        motionService.motionManager.stopDeviceMotionUpdates()
    }
    
    /** callback for swipe down geasture triggers data update from api */
    @objc func screenSwipedDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            locationService.getCurrentLocation()
            loadAsyncWeatherData()
        }
    }
    
    /** called from touching the share button. Loades cached text weather data and opens share dialog */
    @IBAction func shareWeather(_ sender: Any) {
        var shareMyNote = "";
        let weather:ApiModel
        do {
            weather = try weatherService.loadCachedWeatherDataFromLocation()
        } catch let e {
            print("ERROR: Sharing failed: \(e)")
            return
        }
        
        shareMyNote =
            "Weather at " + weather.name + ", " +
            "Temperature " + String(weather.main.temp.rounded()) + " °C, " +
            "Conditions " + weather.weather[0].main
        
        let activityViewController = UIActivityViewController(
            activityItems : [shareMyNote],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated : true, completion : nil )
    }
    

    /** caches weather data */
    func cacheData(key:String, data:Data) {
        if configsService.getDebug() {
            print("DEBUG: Chaching data for \(key): \(data)")
        }
        SHARED_PREFS.setValue(data, forKey: key)
    }
    
    /**  caches strings */
    func cacheString(key:String, str:String) {
        SHARED_PREFS.setValue(str, forKey: key)
    }
    
    /** loads cached weather data */
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
    
    /** loads cached strings */
    func getCachedString(key:String) throws -> String {
        if let str = SHARED_PREFS.string(forKey: key) {
            return str
        } else {
            throw WeatherError.emptyCache(message: "Error loading value for key \(key) from cache")
        }
    }
    
    /** special ui fade out/in and data refresh */
    func updateWeatherDataInView(degrees: String, conditions:String, location:String) {
        // fade out
        animationService.fadeViewOut(view: self.degrees, animationDuration: 0.25)
        animationService.fadeViewOut(view: self.conditions, animationDuration: 0.25)
        animationService.fadeViewOut(view: self.weatherLocationName, animationDuration: 0.25)
        // fade out image too so it looks more syncrounus
        animationService.fadeViewOut(view: self.weatherIcon, animationDuration: 0.25)
        animationService.fadeViewOut(view: self.lastUpdate, animationDuration: 0.25)
        
        // set values
        self.degrees.text = degrees
        self.conditions.text = conditions
        self.weatherLocationName.text = location
        
        // fade in
        animationService.fadeViewIn(view: self.degrees, animationDuration: 1.0)
        animationService.fadeViewIn(view: self.conditions, animationDuration: 1.0)
        animationService.fadeViewIn(view: self.weatherLocationName, animationDuration: 1.0)
    }
    
    /** updates weather image with the one for the new condition */
    func updateWeatherIconInView(data:Data) {
        // update image
        self.weatherIcon.image = UIImage(data: data)
        
        // fade in
        animationService.fadeViewIn(view: self.weatherIcon, animationDuration: 1.0)
    }
    
    /** refreshes last update date in view */
    func updateDateInView(date:String) {
        self.lastUpdate.text = "Last Update: " + date
        animationService.fadeViewIn(view: self.lastUpdate, animationDuration: 1.0)
    }
    
    /** loads cached weather data and image and triggers view update */
    func loadCachedWeatherDataAndUpdateView() {
        do {
             let weatherDataFromCache:ApiModel = try weatherService.loadCachedWeatherDataFromLocation()
            self.updateWeatherDataInView(
                degrees: String(weatherDataFromCache.main.temp.rounded()) + " °C",
                conditions: weatherDataFromCache.weather[0].main,
                location: weatherDataFromCache.name)
        } catch let e {
            print("ERROR: \(e)")
        }
        do {
            let image:Data = try weatherService.loadCachedWeatherImgFromLocation()
            self.updateWeatherIconInView(data: image)
        } catch let e {
            print("ERROR: \(e)")
        }
        do {
            let date:String = try weatherService.loadCachedLastWeatherUpdateFromLocation()
            self.updateDateInView(date: date)
        } catch let e {
            print("ERROR: \(e)")
        }
        
    }
    
    
    @available(*, deprecated, message: "use WeatherService instead")
    func loadCachedWeatherData() throws -> ApiModel {
        do {
            let weather:Data = try getCachedData(key: CacheKeys.main.WEATHER_DATA_LOCATION.rawValue)
            let welcome:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: weather)
            return welcome
        } catch let e {
            print("ERROR: \(e)")
            throw e
        }
    }
    
    /** resolves api query url */
    func urlResolver (query:String) throws -> URL {
        guard apiQuerry == nil else {
            return URL(string: configsService.getApiBaseUrl() +  query + apiQuerry!)!
        }
        throw WeatherError.urlResolver(message: "apiQuerry was nil")
    }
    
    
    /** loads weather image in background and triggers update in view */
    func loadAsyncWeatherImage(code:String) {
        DispatchQueue.global().async {
            do {
                let url = URL(string: configsService.getApiImgBaseUrl() + code + ".png")
                let data = try Data(contentsOf: url!)
                if configsService.getDebug() {
                    print("DEBUG: Load Weather Image from Network: \(data)")
                }
                DispatchQueue.main.async() {
                    self.updateWeatherIconInView(data: data)
                }
                self.cacheData(key: CacheKeys.main.WEATHER_IMAGE_LOCATION.rawValue, data: data)
            } catch let e {
                print("ERROR: \(e)")
                return
            }
        }
    }

    /** loads weather data from api in background */
    func loadAsyncWeatherData() {
        // Add async timeout if location is not loaded yet
        if (nil == locationService.locationQuery) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                self.loadWeatherDataAndUpdateView()
            }
        } else {
            DispatchQueue.global().async {
              self.loadWeatherDataAndUpdateView()
            }
        }
    }
    
    /** loads weather data from api and triggers update in view */
    func loadWeatherDataAndUpdateView() {
        do {
            //let weatherData = try weatherService.loadWeatherDataFromSearch(search: location)
            let weatherData = try weatherService.loadWeatherDataFromLocation()
            
            DispatchQueue.main.async {
                self.updateWeatherDataInView(
                    degrees: String(weatherData.main.temp.rounded()) + " °C",
                    conditions: weatherData.weather[0].main,
                    location: weatherData.name)
                self.updateDateInView(date: getTimestamp())
            }
            self.loadAsyncWeatherImage(code: weatherData.weather[0].icon)
        } catch let e {
            print("ERROR: \(e)")
            return
        }
    }
    
    /** callback for motion notification to decrease the size of view elements */
    override func decreaseSize(_ sender: Any?) {
        if self.degrees.font.pointSize > 20.0 {
            self.degrees.font = UIFont(name: self.degrees.font.fontName, size: self.degrees.font.pointSize-5)
        }
        if self.conditions.font.pointSize > 20.0 {
            self.conditions.font = UIFont(name: self.conditions.font.fontName, size: self.conditions.font.pointSize-5)
        }
        if self.weatherLocationName.font.pointSize > 20.0 {
            self.weatherLocationName.font = UIFont(name: self.weatherLocationName.font.fontName, size: self.weatherLocationName.font.pointSize-3)
        }
    }
    
    /** callback for motion notification to increase the size of view elements */
    override func increaseSize(_ sender: Any?) {
        if self.degrees.font.pointSize < 60.0 {
            self.degrees.font = UIFont(name: self.degrees.font.fontName, size: self.degrees.font.pointSize+5)
            //print("INCREASE \(self.degrees.font.pointSize)")
        }
        if self.conditions.font.pointSize < 60.0 {
            self.conditions.font = UIFont(name: self.conditions.font.fontName, size: self.conditions.font.pointSize+5)
        }
        if self.weatherLocationName.font.pointSize < 60.0 {
            self.weatherLocationName.font = UIFont(name: self.weatherLocationName.font.fontName, size: self.weatherLocationName.font.pointSize+3)
        }
    }
    
}
