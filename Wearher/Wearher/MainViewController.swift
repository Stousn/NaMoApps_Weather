//
//  FirstViewController.swift
//  Wearher
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    
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
        apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
        // Do any additional setup after loading the view, typically from a nib.
        loadCachedWeatherData()
        loadAsyncWeatherData(location: "Leoben,AT")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(screenSwipedDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    @objc func screenSwipedDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            loadAsyncWeatherData(location: "Vienna,AT")
        }
    }
    
    func getTimestamp() -> String {
        let date = Date();
        let formatter = DateFormatter();
        formatter.dateFormat = "d.M HH:mm";
        // formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
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
        self.degrees.text = degrees
        self.conditions.text = conditions
        self.weatherLocationName.text = location
    }
    
    func updateWeatherIconInView(data:Data) {
        self.weatherIcon.image = UIImage(data: data)
    }
    
    func updateDateInView(date:String) {
        self.lastUpdate.text = "Last Update: " + date
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
                let url:URL = try self.urlResolver(query: self.WATHER_QUERY + location)
                if configsService.getDebug() {
                    print("DEBUG: \(url)")
                }
                let data = try Data(contentsOf: url)
                if configsService.getDebug() {
                    print("DEBUG: Load Weather Data from Network: \(data)")
                }
                let welcome:ApiModel = try! JSONDecoder().decode(ApiModel.self, from: data)
                print(welcome.main.temp)
                let now:String = self.getTimestamp()
                DispatchQueue.main.async {
                    self.updateWeatherDataInView(
                        degrees: String(welcome.main.temp.rounded()) + " °C",
                        conditions: welcome.weather[0].main,
                        location: welcome.name)
                    self.updateDateInView(date: now)
                }
                self.cacheData(key: CacheKeys.main.WEATHER_DATA.rawValue, data: data)
                self.cacheString(key: CacheKeys.main.LAST_UPDATE.rawValue, str: now)
                self.loadAsyncWeatherImage(code: welcome.weather[0].icon)
            } catch let e {
                print("ERROR: \(e)")
                return
            }
        }
    }
    
}
