//
//  PlayRoomViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth

class PlayRoomViewModel {
    
    private let playRoom: PlayRoom

    var roomCode: String { playRoom.roomCode }
    var host: User { playRoom.host }
    var members: [User] { playRoom.members }
    var currentTrack: String { playRoom.currentTrack }
    var nextTrack: String { playRoom.nextTrack }
    var queue: [String] { playRoom.queue }
    
    init(with playRoom: PlayRoom) {
        self.playRoom = playRoom
    }
}
