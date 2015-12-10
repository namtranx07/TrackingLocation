//
//  LocationViewController.swift
//  TrackingLocation
//
//  Created by NRHVietNam on 12/9/15.
//  Copyright © 2015 VSC. All rights reserved.
//

import UIKit
import Moscapsule
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var timer:NSTimer!
    var location:CLLocation!
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "runThreadBackground10s", userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.configClient()
        }
        
    }
    
    func runThreadBackground10s()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            //print(self.location)
        }
    }

    //MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = (locations as [CLLocation]).last
        
        /*
        print("latitude: \(locations.last?.coordinate.latitude)")
        print("longitude: \(locations.last?.coordinate.longitude)")
        print("------------------------------------")*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configClient()
    {
        let clientId = "namtran"
        
        let mqttConfig = MQTTConfig(clientId: clientId, host: "127.0.0.1", port: 1883, keepAlive: 1000)
        
        mqttConfig.onConnectCallback = { returnCode in
            NSLog("Return Code is \(returnCode.description) (this callback is declared in swift.)")
        }
        mqttConfig.onDisconnectCallback = { reasonCode in
            NSLog("Reason Code is \(reasonCode.description) (this callback is declared in swift.)")
        }
        
        let mqttClient = MQTT.newConnection(mqttConfig)
        sleep(2)
        print("Check isConnected: \(mqttClient.isConnected)")
        
        mqttClient.subscribe("test/location", qos: 2)
        
    }
    
    
}

