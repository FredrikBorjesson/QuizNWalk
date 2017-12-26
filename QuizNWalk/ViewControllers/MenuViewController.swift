//
//  MenuViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications


class MenuViewController: UIViewController, CLLocationManagerDelegate{

    var locationManager : CLLocationManager!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        self.navigationController?.popViewController(animated: true)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, erroe in
            print("could not allow notifications")
        })
        
        playButton.layer.cornerRadius = 6
        aboutButton.layer.cornerRadius = 6
        profileButton.layer.cornerRadius = 6
        
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }

    ///Validation for GPS to activate
    @IBAction func validateGPS(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("GPS does not work")
            case .authorizedAlways, .authorizedWhenInUse:
                self.navigationController?.navigationBar.isHidden = false;
                if sender.currentTitle == "Play"{
                    performSegue(withIdentifier: "segueToSetupGame", sender: self)
                } else if (sender.currentTitle == "About") {
                    performSegue(withIdentifier: "segueToAbout", sender: self)
                } else {
                    performSegue(withIdentifier: "segueToProfile", sender: self)
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
