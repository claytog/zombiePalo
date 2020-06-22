//
//  ZombieScoreViewController.swift
//  ZombiePalo
//
//  Created by Clayton on 21/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import UIKit

protocol zombieScoreDelegate {
    func reset()
}

class ZombieScoreViewController: UIViewController{

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var againButton: UIButton!

    var message: String!
    var score: Int! = 0
    
    var delegate: zombieScoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        scoreLabel.text = String(score)
        againButton.layer.cornerRadius = 8
    }

    @IBAction func didPressAgain(_ sender: Any) {
        self.delegate?.reset()
        self.dismiss(animated: true, completion: nil)
        
    }
}
