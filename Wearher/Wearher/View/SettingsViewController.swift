//
//  SettingsViewController.swift
//  Wearher
//
//  Created by Stefan Reip on 10.11.18.
//  Copyright © 2018 Stefan Reip. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: SwipableTabViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationSetting: UITextField!
    
    @IBOutlet weak var adaptiveSizeSetting: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSettings()
        adaptiveSizeSetting .addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        locationSetting.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadSettings()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard nil != textField.text else {
            return
        }
        cacheService.cacheString(key: CacheKeys.main.settings.DEFAULT_LOCATION.rawValue, str: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
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
    
    @objc func switchChanged(mySwitch:UISwitch){
        cacheService.cacheBool(key: CacheKeys.main.settings.ADAPTIVE_SIZE_SWITCH.rawValue, bool: mySwitch.isOn)
    }
    
    @IBAction func clearCache(_ sender: Any) {
        cacheService.clearCache()
    }
}


    

