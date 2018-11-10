//
//  ConfigService.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import Foundation

let configsService = Config()

class Config {
    
    private var plistData:[String:AnyObject] = [:]
    
    private var apiBaseUrl:String?
    
    private var apiImgBaseUrl:String?
    
    private var apiKey:String?
    
    private var debug:Bool?

    init() {
        self.readPropertyList()
    }
    
    func getApiBaseUrl() -> String {
        if (apiBaseUrl == nil) {
            self.apiBaseUrl = (plistData[ConfigKeys.API_BASE_URL.rawValue] as! String)
        }
        return self.apiBaseUrl!
    }
    
    func getApiImgBaseUrl() -> String {
        if (apiImgBaseUrl == nil) {
            self.apiImgBaseUrl = (plistData[ConfigKeys.API_IMG_BASE_URL.rawValue] as! String)
        }
        return self.apiImgBaseUrl!
    }
    
    func getApiKey() -> String {
        if (apiKey == nil) {
            self.apiKey = (plistData[ConfigKeys.API_KEY.rawValue] as! String)
        }
        return self.apiKey!
    }
    
    func getDebug() -> Bool {
        if (debug == nil) {
            self.debug = (plistData[ConfigKeys.DEBUG.rawValue] as! Bool)
        }
        return self.debug!
    }
    
    func readPropertyList() {
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
        let plistPath:String? = Bundle.main.path(forResource: "Config", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            self.plistData = try PropertyListSerialization
                .propertyList(from: plistXML,
                              options: .mutableContainersAndLeaves,
                              format: &format) as! [String:AnyObject]
        } catch {
            print("Error reading plist: \(error), format: \(format)")
        }
    }
    
}
