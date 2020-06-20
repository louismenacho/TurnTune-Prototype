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

    var roomCode: String { playRoom.roomCode }
    var token: Token? { playRoom.token }
    
    var host: User { playRoom.host }
    var members: [User] { playRoom.members }
    var currentTrack: String { playRoom.currentTrack }
    var nextTrack: String { playRoom.nextTrack }
    var queue: [String] { playRoom.queue }
    
    let spotifyWebAPI = NetworkManager<SpotifyWebAPI>()
    
    init(with playRoom: PlayRoom) {
        self.playRoom = playRoom
        spotifyWebAPI.setAccessToken(token: token!.access)
        spotifyWebAPI.request(.currentUserProfile) { (user: UserProfile) in
            print(user)
        }
    }
}
