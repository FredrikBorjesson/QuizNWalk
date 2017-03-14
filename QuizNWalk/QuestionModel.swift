//
//  Question.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import Foundation

class Question{

    let question : String
    let correctAnswer : String
    let wrongAnswer1 : String
    let wrongAnswer2 : String
    let wrongAnswer3 : String
    let coordinates : (x: Double, y: Double)
   
    
    init(_ question: String, _  correctAnswer: String, _ wrongAnswer1: String, _ wrongAnswer2: String , _ wrongAnswer3: String, _ coordinates: (Double , Double)){
        self.question = question
        self.correctAnswer = correctAnswer
        self.wrongAnswer1 = wrongAnswer1
        self.wrongAnswer2 = wrongAnswer2
        self.wrongAnswer3 = wrongAnswer3
        self.coordinates = coordinates
    }
    
}
