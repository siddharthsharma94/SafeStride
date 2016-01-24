//
//  InterfaceController.swift
//  SafeStrideWearable Extension
//
//  Created by Siddharth Sharma on 1/23/16.
//  Copyright © 2016 HCS Group. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit
import HealthKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
    var session : WCSession!
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
    }

    @IBAction func callEmergency() {
        let session = WCSession.defaultSession()
        do{
            try session.updateApplicationContext(["contactType" : "phone"])
        }
        catch{
            
        }
    }
    
    
    @IBAction func textEmergency() {
        let session = WCSession.defaultSession()
        do{
            try session.updateApplicationContext(["contactType" : "emergencyText"])
        }
        catch{
            
        }
    }
    
    @IBAction func sendLocation() {
        let session = WCSession.defaultSession()
        do{
            try session.updateApplicationContext(["contactType" : "location"])
        }
        catch{
            
        }
}
}