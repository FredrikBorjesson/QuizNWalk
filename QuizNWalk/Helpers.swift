//
//  Helpers.swift
//  QuizNWalk
//
//  Created by Fredrik Börjesson on 2017-11-23.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuthUI

/*
 Move to the next screen without an animation.
 */
class PushNoAnimationSegue: UIStoryboardSegue {
    
    override func perform() {
        self.source.navigationController?.pushViewController(self.destination, animated: false)
    }
}

class FireStoreHelper {
    
    private init(){}
    static let shared = FireStoreHelper();
    
    func Configure(){
        FirebaseApp.configure()
    }
    
    func Create(){
        
    }
    
    func Read(){
        
    }
    
    func Update(){
        
    }
    
    func Delete(){
        
    }
    
    func Authanticate(delgata: AppDelegate){
        
        
    }
}

