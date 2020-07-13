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
    
    let roomInfo: RoomInfo
    var members = [Member]()
    var currentTrack: String = ""
    var nextTrack: String = ""
    
    init(with roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
    }
}
