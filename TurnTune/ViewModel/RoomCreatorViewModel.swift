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
import FirebaseFirestoreSwift

class RoomCreatorViewModel {
    
    let roomInfo: RoomInfo
    var roomCode: String { roomInfo.code }
    var token: Token? { roomInfo.token }
    
    private let spotifyAccountsService = NetworkManager<SpotifyAccountsService>()
    private let spotifyTokenSwap = NetworkManager<SpotifyTokenSwap>()
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    private let group = DispatchGroup()
 
    init(with roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
    }
    
    func serviceAuthorizeRequest() -> URLRequest {
        return spotifyAccountsService.urlRequest(for: .authorize("695de2c68a184c69aaebdf6b2ed02260", "TurnTune://spotify-login-callback"))!
    }
    
    func generateRoomCode() {
        repeat {
            let letter = Character(UnicodeScalar(Int.random(in: 65...90))!)
            roomInfo.code = "\(roomInfo.code)\(letter)"
        } while roomInfo.code.count < 4
    }
    
    func generateToken(with authorizationCode: String) {
        group.enter()
        spotifyTokenSwap.request(.token(authorizationCode)) { (token: Token) in
            self.roomInfo.token = token
            self.group.leave()
        }
    }
    
    func createRoom() {
        let roomDocumentRef = roomsCollectionRef.document(roomCode)
        roomDocumentRef.setData([
            "date_created": Timestamp(date: Date())
        ])
        
        let hostDocumentRef = roomDocumentRef.collection("members").document("host")
        hostDocumentRef.setData([
            "uid": Auth.auth().currentUser!.uid
        ])
        // notify when token generates
        group.notify(queue: .main) {
            let tokenDocument = roomDocumentRef.collection("info").document("token")
            try! tokenDocument.setData(from: self.token!)
        }
    }
}
