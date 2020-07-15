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
    
    func join(room code: String, name: String, completion: @escaping () -> Void) {
        var signInCompletion: ((User) -> Void)?
        var setDisplayNameCompletion: (() -> Void)?
        var findRoomCompletion: ((DocumentSnapshot) -> Void)?
        var addUserCompletion: (() -> Void)?
        
        signIn { user in
            print("signIn")
            signInCompletion?(user)
        }
        signInCompletion = { user in
            self.setDisplayName(to: name, for: user) {
                print("setDisplayName")
                setDisplayNameCompletion?()
            }
        }
        setDisplayNameCompletion = {
            self.findRoom(with: code) { room in
                print("findRoom")
                findRoomCompletion?(room)
            }
        }
        findRoomCompletion = { room in
            self.addUser(to: room) {
                print("addUser")
                addUserCompletion?()
            }
        }
        addUserCompletion = {
            completion()
        }
    }
    
    func host(completion: @escaping () -> Void) {
        signIn { user in
            completion()
        }
    }
        
    private func signIn(completion: ((User) -> Void)?) {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else {
                print(error ?? "Authentication failed")
                return
            }
            completion?(user)
        }
    }
    
    private func setDisplayName(to name: String, for user: User, completion: (() -> Void)?) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                print(error)
                return
            }
            completion?()
        }
    }
    
    private func findRoom(with code: String, completion: ((DocumentSnapshot) -> Void)?) {
        if code.isEmpty {
            print("Enter a Room Code")
            return
        }
        
        let roomDocumentRef = Firestore.firestore().collection("rooms").document(code)
        roomDocumentRef.getDocument { (documentSnapshot, error) in
            guard let room = documentSnapshot, room.exists else {
                print(error ?? "Room does not exist")
                return
            }
            completion?(room)
        }
    }
    
    private func addUser(to room: DocumentSnapshot, completion: (() -> Void)?) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Unauthorized")
            return
        }
        
        let member = Member(uid: currentUser.uid, name: currentUser.displayName!)
        do {
            try room.reference.collection("members").document(member.uid).setData(from: member)
            completion?()
         } catch {
             print(error)
         }
    }
}
