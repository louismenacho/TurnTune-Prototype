//
//  PlayerViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Combine
import Firebase

class PlayerViewModel: NSObject {
    
    var playerStateDidChange: ((SPTAppRemotePlayerState) -> Void)?
    
    lazy private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy private var appRemote = appDelegate.appRemote
    
    override init() {
        super.init()
        appRemote.delegate = self
        appRemote.connect()
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
        playerStateDidChange?(playerState)
    }
}
