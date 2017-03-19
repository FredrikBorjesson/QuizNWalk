//
//  GameModel.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import Foundation

class Game{
    
    let quizName : String
    let id : Int
    var questions : [Question] = []
    var currentQuestion: Question {
        get {return questions[questionNr - 1]}
    }
    var questionNr = 1
    var correctAnswers = 0
    var length : String = ""
    
    
    init(quizName: String, id: Int) {
        self.quizName = quizName
        self.id = id
    }

}


