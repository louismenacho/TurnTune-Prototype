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
    
    var viewModel : HomeViewModel!

    @IBOutlet weak var roomCodeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomCreatorViewController" {
            let roomInfo = RoomInfo()
            let roomCreatorViewModel = RoomCreatorViewModel(with: roomInfo)
            let roomCreatorViewController = segue.destination as! RoomCreatorViewController
            roomCreatorViewController.viewModel = roomCreatorViewModel
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        viewModel.join(with: roomCodeTextField.text!, name: nameTextField.text!)
        viewModel.getRoomCompletion = { room in
            if room.exists {
                self.performSegue(withIdentifier: "PlayRoomViewController", sender: self)
            } else {
                print("room does not exist")
            }
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
