//
//  Artist.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Artist: Codable {
    var externalUrls: ExternalUrls
    var href: String
    var id: String
    var name: String
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case name = "name"
        case type = "type"
        case uri = "uri"
    }
}
