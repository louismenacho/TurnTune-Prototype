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
    var token: Token
    var playlist: Playlist
    
    var host: User = Auth.auth().currentUser!
    var members = [User]()
    var currentTrack: String = ""
    var nextTrack: String = ""
    
    init(from viewModel: RoomCreatorViewModel) {
        self.roomCode = viewModel.roomCode
        self.token = viewModel.token
        self.playlist = viewModel.playlist
    }
}
