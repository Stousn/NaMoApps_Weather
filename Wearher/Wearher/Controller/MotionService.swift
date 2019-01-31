//
//  MotionService.swift
//  Weather
//
//  Created by Stefan Reip on 28.01.19.
//  Copyright © 2019 Stefan Reip. All rights reserved.
//

import Foundation
import CoreMotion

/** Singelton of class `MotionService`*/
let motionService = MotionService()

/** Motion detection and speeeeeeed calculation */
class MotionService {
    
    let motionManager:CMMotionManager
    
    var previousAccl:CMAcceleration?
    
    var speed: Double = 0.0
    
    init() {
        motionManager = CMMotionManager()
        
    }
    
    /** Checks for motion availability and and starts listening to motion updates every 0.1 secs.
     * Important: Call form `viewDidLoad()`!
     */
    func coreMotion() {
        if self.motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 0.1
            self.motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    [weak self] (deviceMotion, error) -> Void in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    
                    if let deviceMotion = deviceMotion {
                        self?.handleDeviceMotionUpdate(deviceMotion)
                    }
            })
        } else {
            print("ERROR: Device Motion is not available!")
            print("WHAT THE HELL")
        }
    }
    
    /** callback for device motion updates. Calculates speeeed of motion
     * notifies if the size should be increased or decreased
     */
    func handleDeviceMotionUpdate(_ deviceMotion: CMDeviceMotion) {
        let acceleration = deviceMotion.userAcceleration.z
        //let gravity = deviceMotion.gravity.z
        let attitude = deviceMotion.attitude
        let pitch = self.degrees(attitude.pitch)
        
        if configsService.getDebug() {
            let accl = deviceMotion.userAcceleration
            print("DEBUG: Roll: \(attitude.roll), Pitch: \(pitch), Yaw: \(attitude.yaw)")
            print("DEBUG: ACCELRATION: \(accl.x) \(accl.y) \(accl.z)")
            self.calculateSpeed(accl: accl)
            print("DEBUG: SPEED: \(speed)")
        }
      
        
        // Awesome calculation of motion direction and speed
        // flux generator logic
        if (acceleration > 0.15 || acceleration < -0.15 ) {
            if configsService.getDebug() {
                print("DEBUG: PITCH \(pitch)")
            }

            if pitch > 50.0 {
                print("UP")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "increaseSize"), object: nil)
                
            } else if pitch < 35.0 {
                print("DOWN")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "decreaseSize"), object: nil)
                
            }
        }
    }
    
    /** Calc deg from rad */
    func degrees(_ radians: Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    /** speedometer. accl average speed in z direction (only positive) */
    func calculateSpeed(accl: CMAcceleration) {
        self.speed = speed + accl.z * 0.1
        if self.speed < 0 {
            self.speed = 0
        }
    }
    
    
}
