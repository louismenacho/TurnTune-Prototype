//
//  SessionViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/8/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Combine
import Firebase

class SessionViewModel {
    
    var cancellable: AnyCancellable?
    
    func host(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard SpotifyApp.sessionManager.isSpotifyAppInstalled else {
            print("Spotify app not installed")
            return
        }
        cancellable =
            self.spotifyLogin()
        .flatMap { session in
            self.signIn()
        }
        .flatMap { user in
            self.setDisplayName(to: name, for: user)
        }
        .sink(receiveCompletion: {
            switch $0 {
            case let .failure(error):
                completion(.failure(error))
            case .finished:
                completion(.success(()))
            }
        }, receiveValue: { _ in })
    }
    
    private func spotifyLogin() -> Future<SPTSession, Error> {
        Future<SPTSession, Error> { promise in
            SpotifyApp.sessionManager.initiateSession(with: .appRemoteControl, options: .default)
            SpotifyApp.didInitiateSession = { result in
                switch result {
                case .failure(let error):
                    return promise(.failure(error))
                case .success(let session):
                    return promise(.success((session)))
                }
            }
        }
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
    
    private func setDisplayName(to name: String, for user: User) -> Future<User, Error> {
        Future<User, Error> { promise in
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((user)))
                }
            }
        }
    }
    
    private func generateRoomCode() -> String {
        let alphabeticRange = 65...90
        return String( "0000".map{ _ in Character(UnicodeScalar(Int.random(in: alphabeticRange))!)} )
    }
    
    func createRoom(host: User) -> DocumentReference {
        let roomsCollectionRef = Firestore.firestore().collection("rooms")
        let roomDocumentRef = roomsCollectionRef.document(generateRoomCode())
        roomDocumentRef.setData([
            "host": host.uid,
            "dateCreated": Timestamp(date: Date())
        ])
        
        let memberDocumentRef = roomDocumentRef.collection("members").document(host.uid)
        memberDocumentRef.setData([
            "displayName": host.displayName!
        ])
        
        return roomDocumentRef
    }
}
