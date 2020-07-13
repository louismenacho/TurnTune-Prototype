//
//  HomeViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 7/7/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {
    
    var signInCompletion: (() -> Void)?
    var joinRoomCompletion: (() -> Void)?
    
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    
    func signIn(with name: String) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let authResult = authResult else {
                print(error ?? "Authentication failed")
                return
            }
            self.setDisplayName(to: name, for: authResult.user)
            self.signInCompletion?()
        }
    }
    
    func joinRoom(with code: String) {
        if code.isEmpty {
            print("Enter a Room Code")
            return
        }
        
        let roomDocumentRef = roomsCollectionRef.document(code)
        roomDocumentRef.getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot, document.exists else {
                print(error ?? "Room does not exist")
                return
            }
            let memberDocumentRef = roomDocumentRef.collection("members").document(Auth.auth().currentUser!.uid)
            try! memberDocumentRef.setData(from: Member(uid: Auth.auth().currentUser!.uid, name: Auth.auth().currentUser!.displayName!))
            
            self.joinRoomCompletion?()
        }
    }
    
    private func setDisplayName(to name: String, for user: User) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
}
