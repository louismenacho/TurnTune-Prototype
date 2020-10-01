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

class PlayerViewModel {
    
    private var currentTrack: Track?
    private var playerStateCollectionRef: CollectionReference
    
    var currentTrackName: String? { currentTrack?.name }
    var currentTrackArtist: String? { currentTrack?.artist }
    var currentTrackDidChange: (() -> Void)?
    
    init(_ playerStateCollectionRef: CollectionReference) {
        self.playerStateCollectionRef = playerStateCollectionRef
        SpotifyApp.appRemote.connect()
        addPlayerStateListener()
        subscribeSpotifyPlayerState()
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
                self.currentTrackDidChange?()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    private func subscribeSpotifyPlayerState() {
        SpotifyApp.playerStateDidChange = { playerState in
            if self.currentTrack?.uri != playerState.track.uri { // temp workaround for multiple callback
                self.currentTrack = Track(playerState.track)
                print("Write to FireStore")
                do {
                    try self.playerStateCollectionRef.document("currentTrack").setData(from: self.currentTrack)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


