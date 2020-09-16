//
//  RoomViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class RoomViewModel {
    
    private var room: Room
    var roomCode: String { room.roomCode }
    var members: [String] { room.members }
    
    var membersDidChange: (() -> Void)?
    
    let roomsCollectionRef = Firestore.firestore().collection("rooms")
    lazy var roomDocumentRef = roomsCollectionRef.document(roomCode)
    lazy var membersCollectionRef = roomDocumentRef.collection("members")
    
    init(room: Room) {
        self.room = room
        addMembersListener()
    }
    
    func addMembersListener() {
        addSnapshotListener(for: roomDocumentRef.collection("members")) { query in
            self.room.members = query.documents.map({ JSON($0.data())["display_name"].stringValue })
            self.membersDidChange?()
        }
    }
    
    func addSnapshotListener(for collectionReference: CollectionReference, completion: @escaping (QuerySnapshot) -> Void) {
        collectionReference.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let query = querySnapshot else {
                print("No query")
                return
            }
            completion(query)
        }
    }
}
