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
    
    private let roomInfo: RoomInfo
    var roomCode: String { roomInfo.code }
    var roomToken: Token? { roomInfo.token }
    
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
        let alphabeticRange = 65...90
        repeat {
            let letter = Character(UnicodeScalar(Int.random(in: alphabeticRange))!)
            roomInfo.code = "\(roomCode)\(letter)"
        } while roomCode.count < 4
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
        
        let hostDocumentRef = roomDocumentRef.collection("info").document("host")
        hostDocumentRef.setData([
            "uid": Auth.auth().currentUser!.uid
        ])
        
        let memberDocumentRef = roomDocumentRef.collection("members").document(Auth.auth().currentUser!.uid)
        try! memberDocumentRef.setData(from: Member(uid: Auth.auth().currentUser!.uid, name: Auth.auth().currentUser!.displayName!))
        
        // notify when token generates
        group.notify(queue: .main) {
            let tokenDocument = roomDocumentRef.collection("info").document("token")
            try! tokenDocument.setData(from: self.roomToken!)
        }
    }
    
    func getRoomInfo() -> RoomInfo {
        return roomInfo
    }
}
