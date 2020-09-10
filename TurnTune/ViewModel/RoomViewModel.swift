//
//  RoomViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class RoomViewModel {
    
    private var room: Room
    var roomCode: String { room.roomCode }
    
    init(room: Room) {
        self.room = room
    }
    
}
