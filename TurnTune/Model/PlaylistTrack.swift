//
//  PlaylistTrack.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct PlaylistTrack: Codable {
    var addedAt: String
    var addedBy: User
    var isLocal: Bool
    var primaryColor: String?
    var track: Track
    var videoThumbnail: VideoThumbnail

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case primaryColor = "primary_color"
        case track = "track"
        case videoThumbnail = "video_thumbnail"
    }
}
