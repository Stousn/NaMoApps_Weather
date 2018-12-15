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
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var location:CLLocation?
    
    var isInitializedLocation:Bool = false
 
    func getCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("IN LOCATION ENABLED")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        if nil != location {
            let locationCoordinates:CLLocationCoordinate2D = self.location!.coordinate
            print(LAT + String(locationCoordinates.latitude) + LON + String(locationCoordinates.longitude))
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


