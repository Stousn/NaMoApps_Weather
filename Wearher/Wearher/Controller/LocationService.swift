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

/** Loads GPS location and provides `locationQuery:String?` for API call */
class LocationService: NSObject, CLLocationManagerDelegate {
    
    let LAT:String = "lat="
    
    let LON:String = "&lon="
    
    var locationManager:CLLocationManager?
    
    var location:CLLocation?
    
    var isInitializedLocation:Bool = false
    
    /** Location query for API call */
    var locationQuery:String?
    
    override init() {
        super.init()
        if nil != self.location {
            isInitializedLocation = true
        }
    }
 
    /** sets current location in class variable location */
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
    
    /** locationManager success callback sets locationQuery */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        if nil != location {
            let locationCoordinates:CLLocationCoordinate2D = self.location!.coordinate
            print(LAT + String(locationCoordinates.latitude) + LON + String(locationCoordinates.longitude))
            
            locationQuery = LAT + String(locationCoordinates.latitude) + LON + String(locationCoordinates.longitude)
            print("LOCATION QUERY: " + locationQuery!)
        }
        
    }
    
    /** locationManager error callback */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


