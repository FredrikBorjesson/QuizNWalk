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
    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    var allGames : [Game]?
    var selectedGame : Game?
    var gamesStartLocations : [MKPointAnnotation] = []
    
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
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
        let identifier = "quiz"
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = view.annotation as? customMKannotation{
            selectedGame = allGames?.first{($0.id == selectedAnnotation.id)}
            quizNameLabel.text = selectedGame?.quizName
            questionsLabel.text = "Questions: \(selectedGame!.questions.count)"
            var totalDistance : Double = 0
            for index in 0...selectedGame!.questions.count - 2{
                let startLocation = CLLocation(latitude: (selectedGame?.questions[index].coordinates.x)!, longitude: (selectedGame?.questions[index].coordinates.y)!)
                let toLocation = CLLocation(latitude: (selectedGame?.questions[index + 1].coordinates.x)!, longitude: (selectedGame?.questions[index + 1].coordinates.y)!)
                totalDistance += toLocation.distance(from: startLocation)
            }
            lengthLabel.text = "Distance: \(totalDistance)m"
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        quizNameLabel.text = "Pick a quiz"
        questionsLabel.text = "Questions:"
        lengthLabel.text = "Distance"
        selectedGame = nil
    }
    
    
    @IBAction func onStartButton(_ sender: Any) {
        if selectedGame != nil{
            performSegue(withIdentifier: "segueToGame", sender: self)
        } else {
            //Do something, maybe a warning
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueSender = segue.destination as! GameViewController
        segueSender.playerName = nameInput.text
        segueSender.currentGame = selectedGame
    }
    

}

class customMKannotation: MKPointAnnotation{
    let id : Int
    init(id: Int){
        self.id = id
    }
    
}

