//
//  HighscoreViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var higscoreList : [[Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        higscoreList.sort{$0[1] as! Int > $1[1] as! Int}
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return higscoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let player = higscoreList[indexPath.row]
        cell.textLabel?.text = "Name: \(player[0]) Correct answers: \(player[1]) "
        return cell
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
