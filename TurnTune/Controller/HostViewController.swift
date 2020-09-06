//
//  HostViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class HostViewController: UIViewController {
    
    var sessionManager = (UIApplication.shared.delegate as! AppDelegate).sessionManager
    var appRemote = (UIApplication.shared.delegate as! AppDelegate).appRemote
    var playerState: SPTAppRemotePlayerState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionManager.delegate = self
        appRemote.delegate = self
        appRemote.connect()
    }
}

extension HostViewController: SPTSessionManagerDelegate {
    
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

extension HostViewController: SPTAppRemoteDelegate {
    
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

extension HostViewController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
        print("\(playerState.track.name) - \(playerState.track.artist.name)")
        print(playerState.contextURI)
        print(playerState.playbackPosition/1000)
        print(playerState.track.duration/1000)
    }
}

