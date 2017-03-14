//
//  MenuViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit
import MapKit

class MenuViewController: UIViewController, CLLocationManagerDelegate{

    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
    }


    
    @IBAction func validateGPS(_ sender: UIButton) {
        print(CLLocationManager.authorizationStatus())
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("Noooo")
            case .authorizedAlways, .authorizedWhenInUse:
                if sender.currentTitle == "Play"{
                    performSegue(withIdentifier: "segueToSetupGame", sender: self)
                } else if sender.currentTitle == "HighScore"{
                    performSegue(withIdentifier: "segueToHighscore", sender: self)
                } else {
                    performSegue(withIdentifier: "segueToAbout", sender: self)
                }
            }
        }
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
