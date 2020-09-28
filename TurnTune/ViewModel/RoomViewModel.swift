//
//  RoomViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftyJSON

class RoomViewModel {
    
    private var room: Room
    private var roomDocumentRef: DocumentReference
    
    var roomCode: String { room.roomCode }
    var membersCollectionRef: CollectionReference { roomDocumentRef.collection("members") }
    var playerStateCollectionRef: CollectionReference { roomDocumentRef.collection("playerState") }
    
    init(_ roomDocumentRef: DocumentReference) {
        self.roomDocumentRef = roomDocumentRef
        self.room = Room(roomCode: roomDocumentRef.documentID)
    }
}
