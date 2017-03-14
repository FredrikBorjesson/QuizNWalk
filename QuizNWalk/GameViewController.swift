//
//  GameViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit
import GameplayKit
import MapKit

class GameViewController: UIViewController {

    var playerName : String?
    var quizName : String?
    var currentGame : Game?
    var timer = Timer()
    var time = 10
    
    var locationManager : CLLocationManager!
    
    // Map View
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var currentQuestion: UILabel!
    @IBOutlet weak var getQuestionButton: UIButton!

    
    // Quiz view
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionView.isHidden = true
        quizNameLabel.text = currentGame?.quizName
        locationManager = CLLocationManager()
        ///////////
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        if sender.currentTitle == currentGame!.questions[currentGame!.questionNr - 1].correctAnswer{
            sender.backgroundColor = UIColor.green
            currentGame!.correctAnswers += 1
            
        } else {
            sender.backgroundColor = UIColor.red
        }
        if currentGame!.questionNr == 10{
             performSegue(withIdentifier: "fromQuestionToHighscore", sender: self)
        }
        updateCurrentQuestion()
        disableButtons()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchView), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func onGetQuestionButton(_ sender: Any) {
        enableButtons()
        setQuestionAndAnswers()
        switchView()
        time = 10
        startTimer()
        
    }
    
    func setQuestionAndAnswers(){
        questionLabel.text = currentGame!.questions[currentGame!.questionNr - 1].question
        let answersArray = [currentGame!.questions[currentGame!.questionNr - 1].correctAnswer,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer1,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer2,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer3]
        let randomAnswersArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: answersArray)
        answer1Button.setTitle(randomAnswersArray[0] as! String, for: .normal)
        answer2Button.setTitle(randomAnswersArray[1] as! String, for: .normal)
        answer3Button.setTitle(randomAnswersArray[2] as! String, for: .normal)
        answer4Button.setTitle(randomAnswersArray[3] as! String, for: .normal)
    }
    
    func updateCurrentQuestion(){
        currentGame!.questionNr += 1
        currentQuestion.text = "Question: \(currentGame!.questionNr)/\(currentGame!.questions.count)"
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        timerLabel.text = "Time left: \(time)"
    }
    
    func updateTimer(){
        if time > 0{
            time -= 1
            timerLabel.text = "Time left: \(time)"
        } else {
            timer.invalidate()
            switchView()
        }
    }
    
    func switchView(){
        if questionView.isHidden{
            mapView.isHidden = true
            questionView.isHidden = false
        } else {
            mapView.isHidden = false
            questionView.isHidden = true
        }
    }
    
    func noMoreQuestions(){
        performSegue(withIdentifier: "fromQuestionToHighscore", sender: self)
    }
    
    func enableButtons(){
        answer1Button.isEnabled = true
        answer2Button.isEnabled = true
        answer3Button.isEnabled = true
        answer4Button.isEnabled = true
        answer1Button.backgroundColor = UIColor.gray
        answer2Button.backgroundColor = UIColor.gray
        answer3Button.backgroundColor = UIColor.gray
        answer4Button.backgroundColor = UIColor.gray
    }
    
    func disableButtons(){
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        answer3Button.isEnabled = false
        answer4Button.isEnabled = false
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueSender = segue.destination as! HighscoreViewController
        segueSender.quizName = quizName
        segueSender.correctAnswers = currentGame!.correctAnswers
    }
    

}
