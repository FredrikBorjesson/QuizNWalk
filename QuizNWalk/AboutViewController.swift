//
//  AboutViewController.swift
//  QuizNWalk
//
//  Created by Mr X on 2017-03-07.
//  Copyright © 2017 Fredrik Börjesson. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
    }

    @IBAction func onBackButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMenuFromAbout", sender: self)
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
