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
import FirebaseFirestoreSwift
import SwiftyJSON

class PlayerViewModel: NSObject {
    
//    lazy private var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    lazy private var appRemote = appDelegate.appRemote
    private var currentTrack: Track?
    private var playerStateCollectionRef: CollectionReference
    
    var currentTrackName: String? { currentTrack?.name }
    var currentTrackArtist: String? { currentTrack?.artist }
    
    var playerStateDidChange: (() -> Void)?
    
    init(_ playerStateCollectionRef: CollectionReference) {
        self.playerStateCollectionRef = playerStateCollectionRef
        super.init()
//        appRemote.delegate = self
//        appRemote.connect()
        addPlayerStateListener()
        //TODO: Determine where to write data to FireStore
        //TODO: init() parameter must come from FireStore, passed in by RoomViewModel
    }
    
    private func addPlayerStateListener() {
        playerStateCollectionRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let query = querySnapshot else {
                print("No query")
                return
            }
            guard let document = query.documentChanges.filter({ $0.document.documentID == "currentTrack" }).first?.document else {
                print("No document")
                return
            }
            do {
                self.currentTrack = try document.data(as: Track.self)
                self.playerStateDidChange?()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
}

//extension PlayerViewModel: SPTAppRemoteDelegate {
//
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        print("SPTAppRemote connection established")
//        guard let playerAPI = appRemote.playerAPI else {
//            print("playerAPI nil")
//            return
//        }
//        playerAPI.delegate = self
//        playerAPI.subscribe(toPlayerState: { print($1?.localizedDescription ?? "subscribed to playerState") })
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//        }
//    }
//}
//
//extension PlayerViewModel: SPTAppRemotePlayerStateDelegate {
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//
//    }
//}
