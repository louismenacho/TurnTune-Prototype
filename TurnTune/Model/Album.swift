//
//  Album.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Album: Codable {
    var albumType: String
    var artists: [Artist]
    var availableMarkets: [String]
    var externalUrls: ExternalUrls
    var href: String
    var id: String
    var images: [Image]
    var name: String
    var releaseDate: String
    var releaseDatePrecision: String
    var totalTracks: Int
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type = "type"
        case uri = "uri"
    }
}
