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
    var roomCode: String = ""
    var service: ServiceType = .spotify
    var accessToken: String?
    var refreshToken: String?
}
