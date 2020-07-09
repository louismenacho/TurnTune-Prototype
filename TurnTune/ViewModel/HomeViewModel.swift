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
    var getRoomCompletion: (() -> Void)?
    
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    
    func signIn(with name: String) {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.setDisplayName(to: name)
            self.signInCompletion?()
        }
    }
    
    func getRoom(with code: String) {
        if code.isEmpty {
            print("Enter a Room Code")
            return
        }
        roomsCollectionRef.document(code).getDocument { (document, error) in
            if let error = error {
                print(error)
                return
            }
            guard let document = document, document.exists else {
                print("Room does not exist")
                return
            }
            self.getRoomCompletion?()
        }
    }
    
    private func setDisplayName(to name: String) {
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
