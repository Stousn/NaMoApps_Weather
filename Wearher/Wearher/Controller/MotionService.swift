//
//  MotionService.swift
//  Weather
//
//  Created by Stefan Reip on 28.01.19.
//  Copyright © 2019 Stefan Reip. All rights reserved.
//

import Foundation
import CoreMotion

let motionService = MotionService()

class MotionService {
    
    let motionManager:CMMotionManager
    
    var previousAccl:CMAcceleration?
    
    var speed: Double = 0.0
    
    init () {
        motionManager = CMMotionManager()
        
    }
    
    func coreMotion() { // CALLING FROM VIEW DID LOAD
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.1
            self.motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    [weak self] (deviceMotion, error) -> Void in
                    if let error = error {
                        print("ERROR : \(error.localizedDescription)")
                    }
                    
                    if let deviceMotion = deviceMotion {
                        self?.handleDeviceMotionUpdate(deviceMotion)
                    }
            })
        } else {
            print("WHAT THE HELL")
        }
    }
    
    func handleDeviceMotionUpdate(_ deviceMotion: CMDeviceMotion) {
        let acceleration = deviceMotion.userAcceleration.z
        //let gravity = deviceMotion.gravity.z
        let attitude = deviceMotion.attitude
        
        
//        let roll = self.degrees(attitude.roll)
            let pitch = self.degrees(attitude.pitch)
//        let yaw = self.degrees(attitude.yaw)
//        attitude.x
//        let accl = deviceMotion.userAcceleration
//        self.calculateSpeed(accl: accl)
//        self.previousAccl = accl
        //print("Roll: \(roll), Pitch: \(pitch), Yaw: \(yaw)")
        //print("ACCELRATION: \(accl.x) \(accl.y) \(accl.z)")
       // print("SPEED: \(acceleration)")
        
        if (acceleration > 0.15 || acceleration < -0.15 ) {
//            print("PITCH \(pitch)")
            if pitch > 50.0 {
                print("UP")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "increaseSize"), object: nil)
                
            } else if pitch < 35.0 {
                print("DOWN")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "decreaseSize"), object: nil)
                
            }
        }
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    func calculateSpeed(accl: CMAcceleration) {
        self.speed = speed + accl.z * 0.1
        if self.speed < 0 {
            self.speed = 0
        }
    }
    
    
}
