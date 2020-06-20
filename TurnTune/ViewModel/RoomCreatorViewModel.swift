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
    
    var roomCode: String { roomCreator.roomCode }
    var token: Token? { roomCreator.token }
    var service: ServiceType? {
        get { roomCreator.service }
        set { roomCreator.service = newValue }
    }
 
    init(with roomCreator: RoomCreator) {
        self.roomCreator = roomCreator
    }
    
    func generateRoomCode() {
        repeat {
            let letter = Character(UnicodeScalar(Int.random(in: 65...90))!)
            roomCreator.roomCode = "\(roomCreator.roomCode)\(letter)"
        } while roomCreator.roomCode.count < 4
    }
    
    func generateToken(with authorizationCode: String? = nil) {
        switch service! {
        case .spotify:
            let spotifyTokenSwap = NetworkManager<SpotifyTokenSwap>()
            spotifyTokenSwap.request(.token(authorizationCode!)) { (token: Token) in
                self.roomCreator.token = token
            }
        }
    }
    
    func serviceAuthorizeRequest() -> URLRequest {
        switch service! {
        case .spotify:
            let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
            return spotifyAccountsService.urlRequest(for: .authorize("695de2c68a184c69aaebdf6b2ed02260", "TurnTune://spotify-login-callback"))!
        }
    }
}
