//
//  Playlist.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    var collaborative: Bool
    var description: String?
    var externalUrls: ExternalUrls
    var followers: Followers
    var href: String
    var id: String
    var images: [Image]
    var name: String
    var owner: User
    var primaryColor: String?
    var isPublic: Bool
    var snapshotID: String
    var tracks: Paging<Track>
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative = "collaborative"
        case description = "description"
        case externalUrls = "external_urls"
        case followers = "followers"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case owner = "owner"
        case primaryColor = "primary_color"
        case isPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks = "tracks"
        case type = "type"
        case uri = "uri"
    }
}
