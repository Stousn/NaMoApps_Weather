//
//  FirstViewController.swift
//  Wearher
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: SwipableTabViewController {
    
    let SHARED_PREFS = UserDefaults.standard
    
    let WATHER_QUERY:String = "weather?q="

    var apiQuerry:String?

    /** Big current degrees shown top right */
    @IBOutlet weak var degrees: UILabel!
   
    @IBOutlet weak var conditions: UILabel!
    
    @IBOutlet weak var weatherLocationName: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var lastUpdate: UILabel!
    
    // @IBOutlet var screenEdgePanGestureDown: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
        
        apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
        // Do any additional setup after loading the view, typically from a nib.
        loadCachedWeatherData()
        loadAsyncWeatherData(location: "Leoben,AT")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(screenSwipedDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        locationService.getCurrentLocation()
    }
    
    @objc func screenSwipedDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            loadAsyncWeatherData(location: "Vienna,AT")
        }
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
    
    func updateWeatherDataInView(degrees: String, conditions:String, location:String) {
        // fade out
        self.fadeViewOut(view: self.degrees, animationDuration: 0.25)
        self.fadeViewOut(view: self.conditions, animationDuration: 0.25)
        self.fadeViewOut(view: self.weatherLocationName, animationDuration: 0.25)
        // fade out image too so it looks more syncrounus
        self.fadeViewOut(view: self.weatherIcon, animationDuration: 0.25)
        self.fadeViewOut(view: self.lastUpdate, animationDuration: 0.25)
        
        // set values
        self.degrees.text = degrees
        self.conditions.text = conditions
        self.weatherLocationName.text = location
        
        // fade in
        self.fadeViewIn(view: self.degrees, animationDuration: 1.0)
        self.fadeViewIn(view: self.conditions, animationDuration: 1.0)
        self.fadeViewIn(view: self.weatherLocationName, animationDuration: 1.0)
    }
    
    func updateWeatherIconInView(data:Data) {
        // update image
        self.weatherIcon.image = UIImage(data: data)
        
        // fade in
        self.fadeViewIn(view: self.weatherIcon, animationDuration: 1.0)
    }
    
    func updateDateInView(date:String) {
        self.lastUpdate.text = "Last Update: " + date
        self.fadeViewIn(view: self.lastUpdate, animationDuration: 1.0)
    }
    
    func loadCachedWeatherData() {
        do {
            let weather:Data = try getCachedData(key: CacheKeys.main.WEATHER_DATA.rawValue)
            let welcome:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: weather)
            self.updateWeatherDataInView(
                degrees: String(welcome.main.temp.rounded()) + " °C",
                conditions: welcome.weather[0].main,
                location: welcome.name)
        } catch let e {
            print("ERROR: \(e)")
        }
        do {
            let image:Data = try getCachedData(key: CacheKeys.main.WEATHER_IMAGE.rawValue)
            self.updateWeatherIconInView(data: image)
        } catch let e {
            print("ERROR: \(e)")
        }
        do {
            let date:String = try getCachedString(key: CacheKeys.main.LAST_UPDATE.rawValue)
            self.updateDateInView(date: date)
        } catch let e {
            print("ERROR: \(e)")
        }
        
    }
    
    func urlResolver (query:String) throws -> URL {
        guard apiQuerry == nil else {
            return URL(string: configsService.getApiBaseUrl() +  query + apiQuerry!)!
        }
        throw WeatherError.urlResolver(message: "apiQuerry was nil")
    }
    
    func loadAsyncWeatherImage(code:String) {
        DispatchQueue.global().async {
            do {
                let url = try URL(string: configsService.getApiImgBaseUrl() + code + ".png")
                let data = try Data(contentsOf: url!)
                if configsService.getDebug() {
                    print("DEBUG: Load Weather Image from Network: \(data)")
                }
                DispatchQueue.main.async() {
                    self.updateWeatherIconInView(data: data)
                }
                self.cacheData(key: CacheKeys.main.WEATHER_IMAGE.rawValue, data: data)
            } catch let e {
                print("ERROR: \(e)")
                return
            }
        }
    }

    func loadAsyncWeatherData(location:String) {
        DispatchQueue.global().async {
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
    }
    
    func fadeViewIn(view : UIView, animationDuration: Double) {
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        })
    }
    
    func fadeViewOut(view : UIView, animationDuration: Double) {
        // Fade out the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 0
        })
        
    }
    
}
