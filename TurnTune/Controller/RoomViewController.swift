//
//  RoomViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    var roomViewModel: RoomViewModel!
    var playerViewModel: PlayerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomViewModel.roomCode
    }
}



