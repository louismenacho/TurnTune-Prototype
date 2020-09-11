//
//  PlayerViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class PlayerViewModel: NSObject {
    
    var playerState: SPTAppRemotePlayerState?
    
    lazy private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var sessionManager = appDelegate.sessionManager
    lazy var appRemote = appDelegate.appRemote
    
    override init() {
        super.init()
        sessionManager.delegate = self
        appRemote.delegate = self
        appRemote.connect()
    }
    
}

extension PlayerViewModel: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("SPTSession renewed")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
    }
}

extension PlayerViewModel: SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("SPTAppRemote connection established")
        guard let playerAPI = appRemote.playerAPI else {
            print("playerAPI nil")
            return
        }
        playerAPI.delegate = self
        playerAPI.subscribe(toPlayerState: { print($1?.localizedDescription ?? "subscribed to playerState") })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}

extension PlayerViewModel: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
        print("\(playerState.track.name) - \(playerState.track.artist.name)")
        print(playerState.contextURI)
        print(playerState.playbackPosition/1000)
        print(playerState.track.duration/1000)
    }
}
