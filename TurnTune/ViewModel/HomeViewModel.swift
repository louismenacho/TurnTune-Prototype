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
    
    var signInCompletion: ((User) -> Void)?
    var getRoomCompletion: ((DocumentSnapshot) -> Void)?
    var setDisplayNameCompletion: (() -> Void)?
    
    private let roomsCollectionRef = Firestore.firestore().collection("rooms")
    private let group = DispatchGroup()
    
    func join(with roomCode: String, name: String) {
        signIn()
        group.notify(queue: .main) {
            self.getRoom(roomCode)
            self.setDisplayName(name)
        }
    }
    
    private func signIn() {
        group.enter()
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            guard let authResult = authResult else {
                return
            }
            self.signInCompletion?(authResult.user)
            self.group.leave()
        }
    }
    
    private func getRoom(_ code: String) {
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
    
    private func setDisplayName(_ name: String) {
        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print(error)
                return
            }
            self.setDisplayNameCompletion?()
        }
    }
    
}
