//
//  RoomCreatorViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/16/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RoomCreatorViewModel {
    
    private let roomCreator: RoomCreator
    var roomCode: String { roomCreator.roomCode }
    var token: Token { roomCreator.token! }
    
    private let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
    private let spotifyTokenSwap = NetworkManager<SpotifyTokenSwap>()
    private let spotifyWebAPI = NetworkManager<SpotifyWebAPI>()
    
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    
    private let group = DispatchGroup()
    
    var completion: (() -> Void)?
 
    init(with roomCreator: RoomCreator) {
        self.roomCreator = roomCreator
    }
    
    func serviceAuthorizeRequest() -> URLRequest {
        return spotifyAccountsService.urlRequest(for: .authorize("695de2c68a184c69aaebdf6b2ed02260", "TurnTune://spotify-login-callback"))!
    }
    
    func generateRoomCode() {
        repeat {
            let letter = Character(UnicodeScalar(Int.random(in: 65...90))!)
            roomCreator.roomCode = "\(roomCreator.roomCode)\(letter)"
        } while roomCreator.roomCode.count < 4
    }
    
    func generateToken(with authorizationCode: String? = nil) {
        group.enter()
        spotifyTokenSwap.request(.token(authorizationCode!)) { (token: Token) in
            self.roomCreator.token = token
            self.spotifyWebAPI.setAccessToken(token: token.access)
            self.group.leave()
        }
    }
    
    func createRoom() {
        group.wait() // for token to generate
        roomsCollectionRef.document(roomCreator.roomCode).setData([
            "host": Auth.auth().currentUser!.uid, // handle
            "accessToken": token.access,
            "refreshToken": token.refresh!
        ])
        completion?()
    }
}
