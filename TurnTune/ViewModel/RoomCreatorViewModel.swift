//
//  RoomCreatorViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/16/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth

class RoomCreatorViewModel {
    
    private let roomCreator: RoomCreator
    
    var host: User { roomCreator.host }
    var service: ServiceType { roomCreator.service }
    var roomCode: String { roomCreator.roomCode }
 
    init(with roomCreator: RoomCreator) {
        self.roomCreator = roomCreator
        generateRoomCode()
    }
    
    func serviceAuthorization() -> URLRequest {
        switch service {
        case .spotify:
            let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
            return spotifyAccountsService.urlRequest(for: .authorize("", ""))!
        }
    }
    
    func generateRoomCode() {
        var code = ""
        repeat {
            let randomNumber = Int.random(in: 65...90)
            let letter = Character(UnicodeScalar(randomNumber)!)
            code = "\(code)\(letter)"
        } while code.count < 4
        roomCreator.roomCode = code
    }
}
