//
//  Playlist.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    let collaborative: Bool
    let description: String?
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let owner: User
    let primaryColor: String?
    let isPublic: Bool?
    let snapshotID: String
    let tracks: PlaylistTrackResult
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative
        case description = "description"
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case primaryColor = "primary_color"
        case isPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}
