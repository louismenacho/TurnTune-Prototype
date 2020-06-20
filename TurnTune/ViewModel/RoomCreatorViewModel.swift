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
    
    var service: ServiceType { roomCreator.service }
    var roomCode: String { roomCreator.roomCode }
 
    init(with roomCreator: RoomCreator) {
        self.roomCreator = roomCreator
    }
    
    func generateRoomCode() -> String {
        var code = ""
        repeat {
            let letter = Character(UnicodeScalar(Int.random(in: 65...90))!)
            code = "\(code)\(letter)"
        } while code.count < 4
        roomCreator.roomCode = code
        return code
    }
    
    func serviceAuthorization() -> URLRequest {
        switch service {
        case .spotify:
            let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
            return spotifyAccountsService.urlRequest(for: .authorize("695de2c68a184c69aaebdf6b2ed02260", "TurnTune://spotify-login-callback"))!
        }
    }
    
    func generateToken(with authorizationCode: String? = nil) {
        switch service {
        case .spotify:
            let spotifyTokenSwap = NetworkManager<SpotifyTokenSwap>()
            spotifyTokenSwap.request(.token(authorizationCode!)) { token in
                self.roomCreator.accessToken = token?["access_token"] as? String
                self.roomCreator.refreshToken = token?["refresh_token"] as? String
            }
        }
    }
}
