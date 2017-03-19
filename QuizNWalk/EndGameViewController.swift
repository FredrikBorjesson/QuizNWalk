//
//  EndGameViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-17.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var lengthTravelLabel: UILabel!
    @IBOutlet weak var toMenuButton: UIButton!
    
    var currentGame : Game!
    var playerName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toMenuButton.layer.cornerRadius = 6
        quizNameLabel.text = currentGame.quizName
        correctAnswersLabel.text = "Correct answers: \(currentGame.correctAnswers)"
        lengthTravelLabel.text = "Total distance: \(currentGame.length)km"
    }

    override func viewWillDisappear(_ animated: Bool) {
//        var controllers = navigationController?.viewControllers
//        controllers?.remove(at: controllers!.count - 1)
//        navigationController?.viewControllers = controllers!
    }
    
    @IBAction func onToMenuButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMenuFromEnd", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
