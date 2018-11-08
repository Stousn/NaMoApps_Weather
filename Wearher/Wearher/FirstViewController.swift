//
//  FirstViewController.swift
//  Wearher
//
//  Created by Stefan Reip on 07.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Welcome: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
    let pressure, humidity, tempMin, tempMax: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Sys: Codable {
    let type, id: Int
    let message: Double
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
}


extension String: Error {}

class FirstViewController: UIViewController {

    // TODO: Move to global position
    /** URL of weather API */
    let API_URL:String = "http://api.openweathermap.org/data/2.5/"
    
    let IMG_URL:String = "http://openweathermap.org/img/w/"
    
    // TODO: Move to global position
    /** API Key of weather API */
    let API_KEY:String = "3ae7d7caf4a4e14a912fafcea3d68014"
    
    let WATHER_QUERY:String = "weather?q="

    var apiQuerry:String?

    /** Big current degrees shown top right */
    @IBOutlet weak var degrees: UILabel!
   
    @IBOutlet weak var conditions: UILabel!
    
    @IBOutlet weak var weatherLocationName: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiQuerry = "&APPID=" + API_KEY + "&units=metric"
        // Do any additional setup after loading the view, typically from a nib.
        
        loadAsyncWeatherData(location: "Leoben,AT")
    }
    
    func urlResolver (query:String) throws -> URL {
        guard apiQuerry == nil else {
            return URL(string: API_URL +  query + apiQuerry!)!
        }
        throw "Error"
    }
    
    func loadAsyncWeatherImage(code:String) {
        DispatchQueue.global().async {
            do {
                let url = try URL(string: self.IMG_URL + code + ".png")
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.async() {
                    self.weatherIcon.image = UIImage(data: data)
                }
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
                print("DEBUG: \(url)")
                let data = try Data(contentsOf: url)
                print("DEBUG: \(data)")
                let welcome:Welcome = try! JSONDecoder().decode(Welcome.self, from: data)
                print(welcome.main.temp)
                DispatchQueue.main.async {
                    self.degrees.text = String(welcome.main.temp.rounded()) + " °C"
                    self.conditions.text = welcome.weather[0].main
                    self.weatherLocationName.text = welcome.name
                }
                self.loadAsyncWeatherImage(code: welcome.weather[0].icon)
            } catch let e {
                print("ERROR: \(e)")
                return
            }
        }
    }
    
}


