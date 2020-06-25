//
//  Track.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/20/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Track: Codable {
    var album: Album
    var artists: [Artist]
    var durationMS: Int
    var explicit: Bool
    var id: String
    var name: String
    var trackNumber: Int

    enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case durationMS = "duration_ms"
        case explicit = "explicit"
        case id = "id"
        case name = "name"
        case trackNumber = "track_number"
    }
}
