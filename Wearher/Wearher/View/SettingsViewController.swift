//
//  SettingsViewController.swift
//  Weather
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

/** Third view that is loaded when swiped right twice (or tabbed right tab bar icon)
 *  shows settings for the app
 *  set default location for search based weather
 *  set responsive motion based size of weather lables
 *  clear all saved data
 *  (c) info of image
 */
class SettingsViewController: SwipableTabViewController, UITextFieldDelegate {
    
    /** field for setting default location of search based weather */
    @IBOutlet weak var locationSetting: UITextField!
    
    /** switch for enabling/disabling adaptive motion based size of lables */
    @IBOutlet weak var adaptiveSizeSetting: UISwitch!
    
    /** set up on first view load */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** load settings from cache */
        self.loadSettings()
        adaptiveSizeSetting.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        locationSetting.delegate = self
    }
    
    /** reload saved settings when view appears */
    override func viewDidAppear(_ animated: Bool) {
        self.loadSettings()
    }
    
    /** new text is set -> Save setting */
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard nil != textField.text else {
            return
        }
        cacheService.cacheString(key: CacheKeys.main.settings.DEFAULT_LOCATION.rawValue, str: textField.text!)
    }
    
    /** return on text field is pressed -> Close keyboard */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    /** load and set saved settings */
    func loadSettings() {
        do {
            let defaultLocation:String = try cacheService.getCachedString(key: CacheKeys.main.settings.DEFAULT_LOCATION.rawValue)
            let adaptiveSize:Bool = cacheService.getCachedBool(key: CacheKeys.main.settings.ADAPTIVE_SIZE_SWITCH.rawValue)
            
            self.locationSetting.text = defaultLocation
            self.adaptiveSizeSetting.isOn = adaptiveSize
        } catch let e {
            print("ERROR: \(e)")
        }
        
    }
    
    /** callback on switch for adaptive size change */
    @objc func switchChanged(mySwitch:UISwitch){
        cacheService.cacheBool(key: CacheKeys.main.settings.ADAPTIVE_SIZE_SWITCH.rawValue, bool: mySwitch.isOn)
    }
    
    /** clear all saved data and cache
     * nice for the users
     * important for devs
     */
    @IBAction func clearCache(_ sender: Any) {
        cacheService.clearCache()
    }
}


    

