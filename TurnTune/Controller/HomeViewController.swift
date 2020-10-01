//
//  HomeViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/1/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var sessionViewModel: SessionViewModel = SessionViewModel()
    
    @IBOutlet weak var nameCodeTextField: UITextField!
    @IBOutlet weak var roomCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomViewController" {
            let navigationController = segue.destination as! UINavigationController
            let roomViewController = navigationController.viewControllers.first! as! RoomViewController
            roomViewController.roomViewModel = RoomViewModel(sessionViewModel.newRoomDocumentRef!)
        }
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        sessionViewModel.host(name: nameCodeTextField.text!) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RoomViewController", sender: self)
                }
            }
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        sessionViewModel.join(room: roomCodeTextField.text!, name: nameCodeTextField.text!) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RoomViewController", sender: self)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

