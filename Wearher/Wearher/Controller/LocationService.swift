//
//  LocationService.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation
import CoreLocation

/** Singelton of class `CacheService`*/
let locationService = LocationService()

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let LAT:String = "lat="
    
    let LON:String = "&lon="
    
    var locationManager:CLLocationManager?
    
    var location:CLLocation?
    
    var isInitializedLocation:Bool = false
    
    var locationQuery:String?
    
    override init() {
        super.init()
        if nil != self.location {
            isInitializedLocation = true
        }
    }
 
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        self.locationManager!.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("IN LOCATION ENABLED")
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager!.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        if nil != location {
            let locationCoordinates:CLLocationCoordinate2D = self.location!.coordinate
            print(LAT + String(locationCoordinates.latitude) + LON + String(locationCoordinates.longitude))
            
            locationQuery = LAT + String(locationCoordinates.latitude) + LON + String(locationCoordinates.longitude)
            print("LOCATION QUERY: " + locationQuery!)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


