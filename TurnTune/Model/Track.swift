//
//  Track.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Track: Codable {
    var album: Album
    var artists: [Artist]
    var availableMarkets: [String]
    var discNumber: Int
    var durationMS: Int
    var explicit: Bool
    var externalIds: ExternalIds
    var externalUrls: ExternalUrls
    var href: String
    var id: String
    var isLocal: Bool
    var name: String
    var popularity: Int
    var previewURL: String?
    var trackNumber: Int
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit = "explicit"
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type = "type"
        case uri = "uri"
    }
}
