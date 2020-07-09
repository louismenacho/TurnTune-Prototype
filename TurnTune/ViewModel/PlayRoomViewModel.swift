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

    var roomInfo: RoomInfo { playRoom.roomInfo }
    var members: [Member] { playRoom.members }
    var currentTrack: String { playRoom.currentTrack }
    var nextTrack: String { playRoom.nextTrack }
    
    init(with playRoom: PlayRoom) {
        self.playRoom = playRoom
    }
}
