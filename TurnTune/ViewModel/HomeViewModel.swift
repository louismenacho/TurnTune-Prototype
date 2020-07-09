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
    var getRoomCompletion: ((DocumentSnapshot) -> Void)?
    
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    private let group = DispatchGroup()
    
    func signIn() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.signInCompletion?()
        }
    }
    
    func getRoom(with code: String) {
        roomsCollectionRef.document(code).getDocument { (document, error) in
            if let error = error {
                print(error)
                return
            }
            guard let document = document else {
                return
            }
            self.getRoomCompletion?(document)
        }
    }
    
    func setDisplayName(to name: String) {
        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
}
