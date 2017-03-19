//
//  EndGameViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-17.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var lengthTravelLabel: UILabel!
    @IBOutlet weak var toMenuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var highscoreList : [[String]] = []
    var currentGame : Game!
    var playerName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toMenuButton.layer.cornerRadius = 6
        quizNameLabel.text = currentGame.quizName
        lengthTravelLabel.text = "Total distance: \(currentGame.length)km"
        updateHighscoreList()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func updateHighscoreList(){
        if var highscore = UserDefaults.standard.array(forKey: String(currentGame.id)) as? [[String]]{
            let newScore = [playerName!, String(currentGame.correctAnswers)]
            highscore.append(newScore)
            highscoreList = highscore
        } else {
            let newScore = [playerName!, String(currentGame.correctAnswers)]
            highscoreList.append(newScore)
        }
        UserDefaults.standard.set(highscoreList, forKey: String(currentGame.id))
        highscoreList.sort{Int($0[1])! > Int($1[1])!}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.name.text = highscoreList[indexPath.row][0]
        cell.correctAnswers.text = "Correct answers: \(highscoreList[indexPath.row][1])"
        return cell
    }
    
    @IBAction func onToMenuButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMenuFromEnd", sender: self)
    }
}

class CustomCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var correctAnswers: UILabel!


}
