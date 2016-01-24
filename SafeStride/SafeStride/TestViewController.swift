//
//  TestViewController.swift
//  SafeStride
//
//  Created by Siddharth Sharma on 1/23/16.
//  Copyright © 2016 HCS Group. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import WatchConnectivity


class TestViewController: UIViewController, MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate,WCSessionDelegate{
    
    var session: WCSession!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var latLabel: UILabel!
    
    @IBOutlet var emergencyContactButton: UIButton!
    @IBOutlet var emergencyTextButton: UIButton!
    @IBOutlet var sendGeoLocationButton: UIButton!
    
    let locationManager = CLLocationManager()

    @IBOutlet var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        // Do any additional setup after loading the view.
    }

    
    
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            _ = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            _ = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            let longitude = (containsPlacemark.location!.coordinate.longitude)
            let latitude = containsPlacemark.location!.coordinate.latitude
            
            self.areaLabel.text = administrativeArea
            self.localityLabel.text = locality
            self.longitudeLabel.text = longitude.description
            self.latLabel.text = latitude.description
            
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                let test = "Help me! I'm in an urgent situation. Im currently in \(localityLabel.text!) \(areaLabel.text!). The Longitude: \(longitudeLabel.text!), and Latitude: \(self.latLabel.text!). Please Help Me!"
                controller.body = test
                controller.recipients = [phoneNumber.text!]
                controller.messageComposeDelegate = self
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    @IBAction func sendText(sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey I think Im in trouble!"
            controller.recipients = [phoneNumber.text!]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MakeCall(sender:
        AnyObject) {
            let thisLink = "tel://\(self.phoneNumber.text!)"
            print(thisLink)
            let url:NSURL = NSURL(string: thisLink)!
            UIApplication.sharedApplication().openURL(url)
    }
    
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        let currentOperation = applicationContext["contactType"] as! String
        
        if(currentOperation == "phone"){
            MakeCall(emergencyContactButton)
        }
        if(currentOperation == "emergencyText"){
            sendText(emergencyTextButton)
        }
        if(currentOperation == "location"){
            findMyLocation(sendGeoLocationButton)
        }

    
    }
}


