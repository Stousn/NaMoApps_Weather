//
//  SecondViewController.swift
//  Wearher
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

class SearchLocationViewController: SwipableTabViewController, UISearchBarDelegate {
    
    let SHARED_PREFS = UserDefaults.standard
    
    let WATHER_QUERY:String = "weather?q="
    
    var apiQuerry:String?
    
    var location:String = "Leoben,AT"

    @IBOutlet weak var searchLocation: UISearchBar!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var lastUpdate: UILabel!
    
    @IBOutlet weak var degrees: UILabel!
    
    @IBOutlet weak var conditions: UILabel!
    
    @IBOutlet weak var weatherLocationName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
        
        searchLocation.showsScopeBar = true
        searchLocation.delegate = self
        
        apiQuerry = "&APPID=" + configsService.getApiKey() + "&units=metric"
        // Do any additional setup after loading the view, typically from a nib.
        loadCachedWeatherDataAndUpdateView()
        //loadAsyncWeatherData(location: "Leoben,AT")
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(screenSwipedDown))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        
        loadAsyncWeatherData(location: self.location)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.clear
        let backgroundLayer = colorService.gl
        backgroundLayer.frame = view.frame
        self.view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    @objc func screenSwipedDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .recognized {
            locationService.getCurrentLocation()
            loadAsyncWeatherData(location: self.location)
        }
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        guard !(self.searchLocation.text?.isEmpty)! else {
          return
        }
        self.searchLocation.resignFirstResponder()
        self.location = self.searchLocation.text!
        
        loadAsyncWeatherData(location: self.location)
    }
    
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        print("Search Text: \(searchText)")
        // Possible extension: Preload search result here . . .
    }
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
    
    func cacheData(key:String, data:Data) {
        if configsService.getDebug() {
            print("DEBUG: Chaching data for \(key): \(data)")
        }
        SHARED_PREFS.setValue(data, forKey: key)
    }
    
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
    
}

