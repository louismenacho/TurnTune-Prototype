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
            let roomInfo = RoomInfo(host: Auth.auth().currentUser!.uid)
            let roomCreatorViewModel = RoomCreatorViewModel(with: roomInfo)
            let roomCreatorViewController = segue.destination as! RoomCreatorViewController
            roomCreatorViewController.viewModel = roomCreatorViewModel
        }
        if segue.identifier == "PlayRoomViewController" {
            let navigationController = segue.destination as! UINavigationController
            let roomInfo = RoomInfo(code: roomCodeTextField.text!)
            let playRoom = PlayRoom(with: roomInfo)
            let playRoomViewModel = PlayRoomViewModel(with: playRoom)
            let playRoomViewController = navigationController.viewControllers[0] as! PlayRoomViewController
            playRoomViewController.viewModel = playRoomViewModel
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        viewModel.signIn(with: nameTextField.text!)
        viewModel.signInCompletion = {
            self.viewModel.joinRoom(with: self.roomCodeTextField.text!)
        }
        viewModel.joinRoomCompletion = {
            self.performSegue(withIdentifier: "PlayRoomViewController", sender: self)
        }
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        viewModel.signIn(with: nameTextField.text!)
        viewModel.signInCompletion = {
            self.performSegue(withIdentifier: "RoomCreatorViewController", sender: self)
        }
    }
}
