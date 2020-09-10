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

class SessionViewModel: NSObject {
    
    var cancellable: AnyCancellable?
    var newRoom = Room()
    
    lazy private var spotifyLoginCompletion: ((Result<Void, Error>) -> Void)? = nil
    lazy private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var sessionManager = appDelegate.sessionManager
    lazy var appRemote = appDelegate.appRemote
    
    func host(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard sessionManager.isSpotifyAppInstalled else {
            print("Spotify app not installed")
            return
        }
        cancellable =
            self.spotifyLogin()
        .flatMap {
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
        }, receiveValue: {
            self.createRoom()
        })
    }
    
    private func spotifyLogin() -> Future<Void, Error> {
        Future<Void, Error> { promise in
            self.sessionManager.delegate = self
            self.sessionManager.initiateSession(with: .appRemoteControl, options: .default)
            self.spotifyLoginCompletion = { result in
                switch result {
                case .failure(let error):
                    return promise(.failure(error))
                case .success():
                    return promise(.success(()))
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
    
    private func generateRoomCode() {
        var roomCode = ""
        let alphabeticRange = 65...90
        while roomCode.count < 4 {
            let letter = Character(UnicodeScalar(Int.random(in: alphabeticRange))!)
            roomCode = "\(roomCode)\(letter)"
        }
        newRoom.roomCode = roomCode
    }
        
    private func createRoom() {
        generateRoomCode()
        let roomsCollectionRef = Firestore.firestore().collection("rooms")
        
        let roomDocumentRef = roomsCollectionRef.document(newRoom.roomCode)
        roomDocumentRef.setData([
            "date_created": Timestamp(date: Date())
        ])
        
        let memberDocumentRef = roomDocumentRef.collection("members").document(Auth.auth().currentUser!.uid)
        memberDocumentRef.setData([
            "display_name": Auth.auth().currentUser!.displayName!
        ])
    }
}

extension SessionViewModel: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
        appRemote.connectionParameters.accessToken = session.accessToken
        spotifyLoginCompletion?(.success(()))
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error.localizedDescription)
        spotifyLoginCompletion?(.failure(error))
    }
}
