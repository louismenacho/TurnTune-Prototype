//
//  PlayRoom.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth

class PlayRoom {
    
    let roomCode: String
    let token: Token?
    
    var host: User = Auth.auth().currentUser!
    var members = [User]()
    var currentTrack: String = ""
    var nextTrack: String = ""
    var queue = [String]()
    
    init(with roomCode: String, token: Token?) {
        self.roomCode = roomCode
        self.token = token
    }
}
