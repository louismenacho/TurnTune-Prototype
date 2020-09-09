//
//  HomeViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/8/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Combine
import Firebase

class HomeViewModel: NSObject {
    
    private var cancellable: AnyCancellable?
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var spotifyLoginCompletion: ((Result<SPTSession, Error>) -> Void)?
    lazy var sessionManager = appDelegate.sessionManager
    lazy var appRemote = appDelegate.appRemote
    
    func host(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard sessionManager.isSpotifyAppInstalled else {
            print("Spotify app not installed")
            return
        }
        cancellable =
            self.signIn()
        .flatMap { user in
            self.setDisplayName(to: name, for: user)
        }
        .flatMap {
            self.spotifyLogin()
        }
        .sink(receiveCompletion: {
            switch $0 {
            case let .failure(error):
                completion(.failure(error))
            case .finished:
                completion(.success(()))
            }
        }, receiveValue: { session in
            self.appRemote.connectionParameters.accessToken = session.accessToken
        })
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
    
    private func spotifyLogin() -> Future<SPTSession, Error> {
        Future<SPTSession, Error> { promise in
            self.sessionManager.delegate = self
            self.sessionManager.initiateSession(with: .appRemoteControl, options: .default)
            self.spotifyLoginCompletion = { result in
                switch result {
                case let .success(session):
                    return promise(.success(session))
                case let .failure(error):
                    return promise(.failure(error))
                }
            }
        }
    }
}

extension HomeViewModel: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
        spotifyLoginCompletion?(.success(session))
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error.localizedDescription)
        spotifyLoginCompletion?(.failure(error))
    }
}
