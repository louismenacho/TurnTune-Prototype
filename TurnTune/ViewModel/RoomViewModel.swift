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
    var roomCode: String { room.roomCode }
    var members: [String] { room.members }
    var currentTrack: Track? { room.currentTrack }
    var roomStateDidChange: (() -> Void)?
    
    let roomsCollectionRef = Firestore.firestore().collection("rooms")
    lazy var roomDocumentRef = roomsCollectionRef.document(roomCode)
    lazy var membersCollectionRef = roomDocumentRef.collection("members")
    lazy var currentTrackDocumentRef = roomDocumentRef.collection("playerState").document("currentTrack")
    
    init(room: Room) {
        self.room = room
        addMembersListener()
        addCurrentTrackListener()
    }
    
    func updateRoomState(from playerState: SPTAppRemotePlayerState) {
        do {
            try currentTrackDocumentRef.setData(from: Track(playerState.track))
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func addMembersListener() {
        addSnapshotListener(for: roomDocumentRef.collection("members")) { query in
            self.room.members = query.documents.map({ JSON($0.data())["display_name"].stringValue })
            self.roomStateDidChange?()
        }
    }
    
    private func addCurrentTrackListener() {
        addSnapshotListener(for: currentTrackDocumentRef) { document in
            do {
                self.room.currentTrack = try document.data(as: Track.self)
                self.roomStateDidChange?()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    private func addSnapshotListener(for collectionReference: CollectionReference, completion: @escaping (QuerySnapshot) -> Void) {
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
    
    private func addSnapshotListener(for documentReference: DocumentReference, completion: @escaping (DocumentSnapshot) -> Void) {
        documentReference.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let document = documentSnapshot else {
                print("No document")
                return
            }
            completion(document)
        }
    }
}
