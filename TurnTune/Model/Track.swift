//
//  Track.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let duration: Int
    let explicit: Bool
    let id: String
    let name: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case duration = "duration_ms"
        case explicit
        case id
        case name
        case type
    }
}
