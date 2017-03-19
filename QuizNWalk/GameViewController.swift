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
import UserNotifications

class GameViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var playerName : String?
    var currentGame : Game!
    var timer = Timer()
    var time = 10
    var allLoctions : [CLLocationCoordinate2D] = []
    var allAnnotations : [MKAnnotation] = []
    var inRegion = true
    var currentRegion : CLCircularRegion!
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
        
        answer1Button.layer.cornerRadius = 6
        answer2Button.layer.cornerRadius = 6
        answer3Button.layer.cornerRadius = 6
        answer4Button.layer.cornerRadius = 6
        getQuestionButton.layer.cornerRadius = 6
        questionLabel.layer.cornerRadius = 6
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        getQuestionButtonShow()
        showQuestionAnnotations()
        stopMonitoringRegions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopMonitoringRegions()
        getQuestionButtonShow()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        if sender.currentTitle == currentGame!.questions[currentGame!.questionNr - 1].correctAnswer{
            sender.backgroundColor = UIColor.green
            currentGame!.correctAnswers += 1
            
        } else {
            sender.backgroundColor = UIColor.red
        }
        nextQuestion()
    }
    
    func nextQuestion(){
        if currentGame!.questionNr == currentGame.questions.count {
            stopMonitoringRegions()
            performSegue(withIdentifier: "fromQuestionToEndGame", sender: self)
        } else {
            updateCurrentQuestion()
            disableButtons()
            getQuestionButtonHide()
            startMontitoringQuestion()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchView), userInfo: nil, repeats: false)
            inRegion = false
            print(currentGame.questionNr)
        }

    }
    
    @IBAction func onGetQuestionButton(_ sender: Any) {
        print("GetQuestion is pressed")
        if inRegion{
            enableButtons()
            setQuestionAndAnswers()
            switchView()
            time = 10
            startTimer()
        }
    }
    
    func setQuestionAndAnswers(){
        questionLabel.text = currentGame!.questions[currentGame!.questionNr - 1].question
        let answersArray = [currentGame!.questions[currentGame!.questionNr - 1].correctAnswer,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer1,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer2,
                            currentGame!.questions[currentGame!.questionNr - 1].wrongAnswer3]
        let randomAnswersArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: answersArray)
        answer1Button.setTitle(randomAnswersArray[0] as? String, for: .normal)
        answer2Button.setTitle(randomAnswersArray[1] as? String, for: .normal)
        answer3Button.setTitle(randomAnswersArray[2] as? String, for: .normal)
        answer4Button.setTitle(randomAnswersArray[3] as? String, for: .normal)
    }
    
    func updateCurrentQuestion(){
        let annotation = allAnnotations[currentGame.questionNr - 1]
        mapView.removeAnnotation(annotation)
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        mapView.addAnnotation(annotationView.annotation!)
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
            nextQuestion()
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
 
    
    func enableButtons(){
        answer1Button.isEnabled = true
        answer2Button.isEnabled = true
        answer3Button.isEnabled = true
        answer4Button.isEnabled = true
        answer1Button.backgroundColor = UIColor.white
        answer2Button.backgroundColor = UIColor.white
        answer3Button.backgroundColor = UIColor.white
        answer4Button.backgroundColor = UIColor.white
    }
    
    func disableButtons(){
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        answer3Button.isEnabled = false
        answer4Button.isEnabled = false
    }
    
    func getQuestionButtonShow(){
        getQuestionButton.backgroundColor = UIColor.white
        getQuestionButton.alpha = 1.0
    }
    
    func getQuestionButtonHide(){
        getQuestionButton.backgroundColor = UIColor.lightGray
        getQuestionButton.alpha = 0.5
    }
    
    //Map functions below
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: false)
        }
    }
    
    func startMontitoringQuestion(){
        stopMonitoringRegions()
        print("\(locationManager.monitoredRegions.count) i startMonitoring 1")
        let newLocation = allLoctions[currentGame.questionNr - 1]
        currentRegion = CLCircularRegion(center: newLocation, radius: 10, identifier: "questionFence")
        print(currentRegion)
        locationManager.startMonitoring(for: currentRegion)
        print("\(locationManager.monitoredRegions.count) i startMonitoring 2")
    }
    
    func stopMonitoringRegions(){
        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(locationManager.monitoredRegions.count)
        displayNotification()
        getQuestionButtonShow()
        inRegion = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        getQuestionButtonHide()
        inRegion = false
    }
    
    func showQuestionAnnotations(){
        for (i, question) in currentGame.questions .enumerated(){
            
            let annotation = customMKannotation(id: i + 1)
            annotation.title = "Question nr: \(i+1)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: question.coordinates.x,
                                                           longitude: question.coordinates.y)
            allLoctions.append(annotation.coordinate)
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            allAnnotations.append(annotationView.annotation!)
            mapView.addAnnotation(annotationView.annotation!)
        }
        
        let polyLine = MKPolyline(coordinates: allLoctions, count: allLoctions.count)
        mapView.add(polyLine)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if let annotation = annotation as? customMKannotation{
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.canShowCallout = true
            annotationView.annotation = annotation
            if annotation.id < currentGame.questionNr{
                annotationView.image = #imageLiteral(resourceName: "questionGray")
            } else {
                annotationView.image = #imageLiteral(resourceName: "questionGreen")
            }
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKPolylineRenderer()
    }
    
    // Notification funtions
    
    func displayNotification(){
        let content = UNMutableNotificationContent()
        content.title = "You're at the question!"
        content.body = ""   //Only seem to work if these are set
        content.subtitle = "" // This too
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notificationRequest", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueSender = segue.destination as! EndGameViewController
            segueSender.currentGame = currentGame
            segueSender.playerName = playerName
    
    }
    

}
