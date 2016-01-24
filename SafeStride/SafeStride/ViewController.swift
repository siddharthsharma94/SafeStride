//
//  ViewController.swift
//  SafeStride
//
//  Created by Siddharth Sharma on 1/23/16.
//  Copyright © 2016 HCS Group. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI
import AVFoundation

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var fadeCode: UILabel!
    @IBOutlet var phoneNumber: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //fadeCode.alpha = 0
        animateText();
    }
    

    
    @IBAction func sendText(sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
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
    
//    @IBAction func sendMessage(sender: AnyObject) {
//        var messageVC = MFMessageComposeViewController()
//        
//        messageVC.body = "Enter a message";
//        messageVC.recipients = ["Enter tel-nr"]
//        messageVC.messageComposeDelegate = self;
//        
//        self.presentViewController(messageVC, animated: false, completion: nil)
//    }
    
    
    
    func animateText(){
        UIView.animateWithDuration(1.0, animations: {
            //self.fadeCode.alpha = 1.0
            }, completion: {
                (Completed : Bool) -> Void in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

