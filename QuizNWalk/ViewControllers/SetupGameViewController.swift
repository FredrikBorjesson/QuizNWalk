//
//  SetupGameViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit
import MapKit

class SetupGameViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    var locationManager : CLLocationManager!
    var allGames : [Game]?
    var selectedGame : Game?
    var gamesStartLocations : [MKPointAnnotation] = []
    var startBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = 10
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        allGames = getGames()
        showGamesAnnotations()
        startButton.layer.cornerRadius = 6
        warningLabel.layer.cornerRadius = 5
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMenuFromAbout", sender: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        startBool = false
    }

   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: true)
        }
    }
    
    func showGamesAnnotations(){
        for game in allGames!{
            let annotation = customMKannotation(id: 1)
            annotation.title = game.quizName
            let firstQuestion = game.questions[0]
            annotation.coordinate = CLLocationCoordinate2D(latitude: firstQuestion.coordinates.x,
                                                           longitude: firstQuestion.coordinates.y)
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "quiz")
            mapView.addAnnotation(annotationView.annotation!)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let quizAnnotation = annotation as? customMKannotation{
            let identifier = "quiz"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: quizAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = quizAnnotation
            }
            annotationView?.image = #imageLiteral(resourceName: "chooseQuiz")
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = view.annotation as? customMKannotation{
            selectedGame = allGames?.first{($0.id == selectedAnnotation.id)}
            questionsLabel.text = "Questions: \(selectedGame!.questions.count)"
            var totalDistance : Double = 0
            for index in 0...selectedGame!.questions.count - 2{
                let startLocation = CLLocation(latitude: (selectedGame?.questions[index].coordinates.x)!, longitude: (selectedGame?.questions[index].coordinates.y)!)
                let toLocation = CLLocation(latitude: (selectedGame?.questions[index + 1].coordinates.x)!, longitude: (selectedGame?.questions[index + 1].coordinates.y)!)
                totalDistance += toLocation.distance(from: startLocation)
            }
            totalDistance = totalDistance/1000
            let roundedDistance = String(format: "%.2f", totalDistance)
            selectedGame?.length = roundedDistance
            lengthLabel.text = "Total distance: \(roundedDistance)km"
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        questionsLabel.text = "Questions:"
        lengthLabel.text = "Total distance:"
        selectedGame = nil
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
    @IBAction func onStartButton(_ sender: Any) {
        let nameLength = nameInput.text?.count
        if selectedGame != nil && nameLength! > 2 && nameLength! < 15{
            startBool = true
            performSegue(withIdentifier: "segueToGame", sender: self)
        } else {
            animateWarning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if startBool{
            let segueSender = segue.destination as! GameViewController
            segueSender.playerName = nameInput.text
            segueSender.currentGame = selectedGame
        }
    }
    
    func animateWarning(){
        UIView.animate(withDuration: 1, animations: {
            self.warningLabel.alpha = 1
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(Timer) in
            UIView.animate(withDuration: 2, animations: {
                self.warningLabel.alpha = 0
            })
        })
    }
}

class customMKannotation: MKPointAnnotation{
    let id : Int
    var questionAnswered = false
    init(id: Int){
        self.id = id
    }
    
}

