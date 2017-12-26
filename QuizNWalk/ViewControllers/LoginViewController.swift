//
//  LoginViewController.swift
//  QuizNWalk
//
//  Created by Fredrik Börjesson on 2017-12-09.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI

///Used to prevent conflicts with other classes that uses "User"
typealias FIRUser = FirebaseAuth.User

///Viewcontroller for login flow
class LoginViewController: UIViewController{

    @IBOutlet weak var loginRegisterButton: UIButton!
    
    override func viewDidLoad() {
        loginRegisterButton.layer.cornerRadius = 6
    }
    
    ///Calls when LoginRegisterButton is pressed and delegates googles UI for authentication
    @IBAction func LoginRegisterPressed(_ sender: Any) {
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else {return}
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
    }
}

///Extension for the controller to use googles UI
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let initialViewController = storyboard.instantiateInitialViewController() {
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    
}
