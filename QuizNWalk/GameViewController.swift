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

class GameViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var playerName : String?
    var currentGame : Game!
    var timer = Timer()
    var time = 10
    var allLoctions : [CLLocationCoordinate2D] = []
    
    var locationManager : CLLocationManager!
    
    // Map View
    
    @IBOutlet weak var walkView: UIView!
    @IBOutlet weak var mapView: MKMapView!
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
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = 10
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        showQuestionAnnotations()
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
            walkView.isHidden = true
            questionView.isHidden = false
        } else {
            walkView.isHidden = false
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
    
    //Map functions below
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        /// Hej
    }
    
    func showQuestionAnnotations(){
        for (i, question) in currentGame.questions .enumerated(){
            print( "\(i)")
            let annotation = customMKannotation(id: 1.0 + Float(i)/10)
            annotation.title = "Question nr: \(i+1)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: question.coordinates.x,
                                                           longitude: question.coordinates.y)
            allLoctions.append(annotation.coordinate)
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "question")
            mapView.addAnnotation(annotationView.annotation!)
        }
        let polyLine = MKPolyline(coordinates: allLoctions, count: allLoctions.count)
        mapView.add(polyLine)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "question"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = #imageLiteral(resourceName: "quizAnnotationImage")
        return annotationView
  }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKPolylineRenderer()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueSender = segue.destination as! HighscoreViewController
        segueSender.quizName = currentGame.quizName
        segueSender.correctAnswers = currentGame!.correctAnswers
    }
    

}
