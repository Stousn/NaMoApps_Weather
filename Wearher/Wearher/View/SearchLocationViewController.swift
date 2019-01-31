//
//  SecondViewController.swift
//  Weather
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

/** Second view that is loaded when swiped right once (or tabbed center tab bar icon)
 *  loads weather data for search location (default cen be set in settings)
 *  swipe down for update
 *  calculated ui color for date time
 *  increases and decreases size of texts when moved up or down (if enabled)
 */
class SearchLocationViewController: SwipableTabViewController, UISearchBarDelegate {
    
    let SHARED_PREFS = UserDefaults.standard
    
    let WATHER_QUERY:String = "weather?q="
    
    var apiQuerry:String?
    
    var location:String = "Leoben,AT"

    /** Search bar for weather location */
    @IBOutlet weak var searchLocation: UISearchBar!
    
    /** Low res image of current weather condition provided by the api */
    @IBOutlet weak var weatherIcon: UIImageView!
    
    /** Timestamp of last weather update */
    @IBOutlet weak var lastUpdate: UILabel!
    
    /** Big current degrees shown top right */
    @IBOutlet weak var degrees: UILabel!
    
    /** Main weather condition shown below city name */
    @IBOutlet weak var conditions: UILabel!
    
    /** Name of searched city (where the weather data belongs to) */
    @IBOutlet weak var weatherLocationName: UILabel!
    
    /** Called on first load of view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the colors
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
        
        
        // Set up search bar
        searchLocation.showsScopeBar = true
        searchLocation.delegate = self
        
         // Load weather data syncronously from cache and check current location
        apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
        loadCachedWeatherDataAndUpdateView()
        
        // Register swipe down update gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(screenSwipedDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        // Load weather data asynchronously from the api
        loadCachedLocation()
        loadAsyncWeatherData(location: self.location)
        
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
            loadAsyncWeatherData(location: self.location)
        }
    }
    
    /** called when search bar enter on virtual keyboard is pressed
     *  updates location and triggers ansync weather api call
     */
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        guard !(self.searchLocation.text?.isEmpty)! else {
          return
        }
        self.searchLocation.resignFirstResponder()
        self.location = self.searchLocation.text!
        
        loadAsyncWeatherData(location: self.location)
    }
    
    /** called whenever the text in the search bar is changed
     *  Only used for logging
     *  Extension point for preloading of weather results
     *  Extension point for autocomplete of search texts
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if configsService.getDebug() {
            print("DEBUG: Search Text: \(searchText)")
        }
        // Possible extension: Preload search result here . . .
    }
    
    /** loads cached weather data and image and triggers view update */
    func loadCachedWeatherDataAndUpdateView() {
        do {
            let weatherDataFromCache:ApiModel = try weatherService.loadCachedWeatherDataFromSearch()

            self.updateWeatherDataInView(
                degrees: String(weatherDataFromCache.main.temp.rounded()) + " °C",
                conditions: weatherDataFromCache.weather[0].main,
                location: weatherDataFromCache.name)
        } catch let e {
            print("ERROR: \(e)")
        }
        do {
            let image:Data = try weatherService.loadCachedWeatherImgFromSearch()
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
    
    /** Loads weather data for location from api in background */
    func loadAsyncWeatherData(location:String) {
        // Add async timeout if location is not loaded yet
        if (nil == locationService.locationQuery) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.loadWeatherDataAndUpdateView(location: location)
            }
        } else {
            DispatchQueue.global().async {
                self.loadWeatherDataAndUpdateView(location: location)
            }
        }
    }
    
    /** Updates weather image of current condition in view */
    func updateWeatherIconInView(data:Data) {
        // update image
        self.weatherIcon.image = UIImage(data: data)
        
        // fade in
        animationService.fadeViewIn(view: self.weatherIcon, animationDuration: 1.0)
    }
    
    func updateDateInView(date:String) {
        self.lastUpdate.text = "Last Update: " + date
        animationService.fadeViewIn(view: self.lastUpdate, animationDuration: 1.0)
    }
    
    /** Loads weather data async from api and triggers update in view */
    func loadWeatherDataAndUpdateView(location:String) {
        do {
            let weatherData = try weatherService.loadWeatherDataFromSearch(search: location)
            
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
    
    /** Loads weather image of current condition in background */
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
                self.cacheData(key: CacheKeys.main.WEATHER_IMAGE_SEARCH.rawValue, data: data)
            } catch let e {
                print("ERROR: \(e)")
                return
            }
        }
    }
    
    /** convenience method to cache weather data */
    func cacheData(key:String, data:Data) {
        if configsService.getDebug() {
            print("DEBUG: Chaching data for \(key): \(data)")
        }
        SHARED_PREFS.setValue(data, forKey: key)
    }
    
    /** loads location of last weather search from cache and sets it as `self.location` */
    func loadCachedLocation() {
        do {
            let cachedLocation = try cacheService.getCachedString(key: CacheKeys.main.settings.DEFAULT_LOCATION.rawValue)
            if "" != cachedLocation {
                self.location = cachedLocation
            }
        } catch let e {
            print("ERROR: \(e)")
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
    
    /** callback for motion notification to decrease the size of view elements */
    override func decreaseSize(_ sender: Any?) {
        if self.degrees.font.pointSize > 20.0 {
            self.degrees.font = UIFont(name: self.degrees.font.fontName, size: self.degrees.font.pointSize-5)
            //print("DECREASE \(self.degrees.font.pointSize)")
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
        }
        if self.conditions.font.pointSize < 60.0 {
            self.conditions.font = UIFont(name: self.conditions.font.fontName, size: self.conditions.font.pointSize+5)
        }
        if self.weatherLocationName.font.pointSize < 60.0 {
            self.weatherLocationName.font = UIFont(name: self.weatherLocationName.font.fontName, size: self.weatherLocationName.font.pointSize+3)
        }
    }
    
}

