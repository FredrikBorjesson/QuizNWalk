//
//  Profile.swift
//  QuizNWalk
//
//  Created by Fredrik Börjesson on 2017-11-22.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import Foundation

class Profile{
    let name : String
    let id : String
    let email : String
    let playedQuiz : [String]
    var score : Int = 0
    
    init(_ name: String, _ id: String, _ email: String, _ playedQuiz: [String]) {
        self.name = name
        self.id = id
        self.email = email
        self.playedQuiz = playedQuiz
    }
}

func CreateProfile(name: String, email: String) -> Profile{
    return Profile(name, UUID().uuidString, email, [])
}

func DeleteProfile(ID: String){
    
}
