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
        if segue.identifier == "PlayRoomViewController" {
            
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        viewModel.signIn()
        viewModel.signInCompletion = {
            self.viewModel.getRoom(with: self.roomCodeTextField.text!)
            self.viewModel.setDisplayName(to: self.nameTextField.text!)
        }
        viewModel.getRoomCompletion = { room in
            guard room.exists else {
                print("room does not exist")
                return
            }
            self.performSegue(withIdentifier: "PlayRoomViewController", sender: self)
        }
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        viewModel.signIn()
        viewModel.signInCompletion = {
            self.performSegue(withIdentifier: "RoomCreatorViewController", sender: self)
        }
    }
}
