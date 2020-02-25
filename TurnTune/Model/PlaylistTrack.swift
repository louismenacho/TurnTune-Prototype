//
//  PlaylistTrack.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/24/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct PlaylistTrack: Codable {
    var primaryColor: String?
    var addedAt: String
    var addedBy: User
    var isLocal: Bool
    var track: Track

    enum CodingKeys: String, CodingKey {
        case primaryColor = "primary_color"
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case track
    }
}
