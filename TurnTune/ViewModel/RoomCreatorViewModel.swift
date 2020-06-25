//
//  RoomCreatorViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/16/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class RoomCreatorViewModel {
    
    private let roomCreator: RoomCreator
    var roomCode: String { roomCreator.roomCode }
    var token: Token { roomCreator.token! }
    var playlist: Playlist { roomCreator.playlist! }
    
    private let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
    private let spotifyTokenSwap = NetworkManager<SpotifyTokenSwap>()
    private let spotifyWebAPI = NetworkManager<SpotifyWebAPI>()
    
    private let group = DispatchGroup()
    
    var taskCompletion: (() -> Void)?
 
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
    
    func createPlaylist() {
        group.wait() // for token to generate
        spotifyWebAPI.request(.currentUserProfile) { (user: UserProfile) in
            self.spotifyWebAPI.request(.createPlaylist(user.id, "TurnTune")) { (playlist: Playlist) in
                self.roomCreator.playlist = playlist
                DispatchQueue.main.async { self.taskCompletion?() }
            }
        }
    }
}
