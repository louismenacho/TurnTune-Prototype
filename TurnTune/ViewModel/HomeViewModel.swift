//
//  HomeViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 7/7/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {
    
    var cancellable: AnyCancellable?
    
    func join(room code: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        cancellable =
            signIn()
        .flatMap { user in
            self.setDisplayName(to: name, for: user)
        }
        .flatMap {
            self.findRoom(with: code)
        }
        .flatMap { room in
            self.addUser(to: room)
        }
        .eraseToAnyPublisher()
        .sink(receiveCompletion: {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                completion(.success(()))
            }
        }){_ in}
    }
    
    func host(completion: @escaping (Result<Void, Error>) -> Void) {
        cancellable = signIn().sink(receiveCompletion: {
            switch $0 {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                completion(.success(()))
            }
        }){_ in}
    }
        
    private func signIn() -> Future<User, Error> {
        Future<User, Error> { promise in
            Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                } else
                if let user = authResult?.user {
                    promise(.success(user))
                }
            }
        }
    }
    
    private func setDisplayName(to name: String, for user: User) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    private func findRoom(with code: String) -> Future<DocumentSnapshot, Error> {
        Future<DocumentSnapshot, Error> { promise in
            if code.isEmpty {
                promise(.failure(TurnTuneError.invalidRoomCode))
            }
            let roomDocumentRef = Firestore.firestore().collection("rooms").document(code)
            roomDocumentRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                }
                guard let room = documentSnapshot, room.exists else {
                    promise(.failure(TurnTuneError.invalidRoomCode))
                    return
                }
                promise(.success(room))
            }
        }
    }
    
    private func addUser(to room: DocumentSnapshot) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            guard let currentUser = Auth.auth().currentUser else {
                promise(.failure(TurnTuneError.unauthorized))
                return
            }
            do {
                let member = Member(uid: currentUser.uid, name: currentUser.displayName!)
                try room.reference.collection("members").document(member.uid).setData(from: member)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
