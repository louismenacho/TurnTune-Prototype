//
//  Track.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/17/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import SwiftyJSON

class Track: Codable {
    var uri: String
    var name: String
    var artist: String
    var album: String
    var duration: UInt
    var imageIdentifier: String?
    
    init(_ track: JSON) {
        uri = track["uri"].stringValue
        name = track["name"].stringValue
        artist = track["artists"].arrayValue.map({ $0["name"].stringValue }).joined(separator: ", ")
        album = track["album"]["name"].stringValue
        duration = track["duration_ms"].uIntValue
        imageIdentifier = nil
    }
    
    init(_ track: SPTAppRemoteTrack) {
        uri = track.uri
        name = track.name
        artist = track.artist.name
        album = track.album.name
        duration = track.duration
        imageIdentifier = track.imageIdentifier
    }
}
