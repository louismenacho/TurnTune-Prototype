//
//  PlayRoomViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PlayRoomViewModel {
    
    private let playRoom: PlayRoom
    private let roomDocumentRef: DocumentReference

    var roomInfo: RoomInfo { playRoom.roomInfo }
    var members: [Member] { playRoom.members }
    var currentTrack: String { playRoom.currentTrack }
    var nextTrack: String { playRoom.nextTrack }
    
    init(with playRoom: PlayRoom) {
        self.playRoom = playRoom
        self.roomDocumentRef = Firestore.firestore().collection("rooms").document(playRoom.roomInfo.code)
    }
}
