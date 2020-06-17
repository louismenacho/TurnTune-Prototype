//
//  RoomCreator.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/16/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth

enum ServiceType {
    case spotify
}

class RoomCreator {
    
    let host: User
    var service: ServiceType = .spotify
    var roomCode: String = ""
    
    init(with host: User) {
        self.host = host
    }
}
