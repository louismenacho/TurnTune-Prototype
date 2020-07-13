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
import FirebaseFirestoreSwift

class PlayRoomViewModel {
    
    var membersChanged: (([Member]) -> Void)?
    
    private let playRoom: PlayRoom
    var roomInfo: RoomInfo { playRoom.roomInfo }
    var members: [Member] { playRoom.members }
    var currentTrack: String { playRoom.currentTrack }
    var nextTrack: String { playRoom.nextTrack }
    
    private let roomDocumentRef: DocumentReference
    
    init(with playRoom: PlayRoom) {
        self.playRoom = playRoom
        self.roomDocumentRef = Firestore.firestore().collection("rooms").document(playRoom.roomInfo.code)
        roomDocumentRef.collection("members").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let query = querySnapshot else {
                print("No query")
                return
            }
            playRoom.members = query.documents.map { try! $0.data(as: Member.self)! }
            self.membersChanged?(self.members)
        }
    }
}
