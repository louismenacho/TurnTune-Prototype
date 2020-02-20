//
//  Album.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Album: Codable {
    let artists: [Artist]
    let id: String
    let images: [Image]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case artists, id, images, name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case type
    }
}
