//
//  HomeViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomCreatorViewController" {
            let roomCreator = RoomCreator()
            let roomCreatorViewModel = RoomCreatorViewModel(with: roomCreator)
            let roomCreatorViewController = segue.destination as! RoomCreatorViewController
            roomCreatorViewController.roomCreatorViewModel = roomCreatorViewModel
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "PlayRoomViewController", sender: self)
        }
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "RoomCreatorViewController", sender: self)
        }
    }
}
