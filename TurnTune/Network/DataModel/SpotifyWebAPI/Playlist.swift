//
//  Playlist.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/20/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    var id: String
    var name: String
    var owner: UserProfile
    var snapshotID: String
    var tracks: Paging<Track>

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case owner = "owner"
        case snapshotID = "snapshot_id"
        case tracks = "tracks"
    }
}
