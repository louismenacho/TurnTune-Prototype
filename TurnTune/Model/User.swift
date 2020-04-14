//
//  User.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct User: Codable {
    var displayName: String?
    var externalUrls: ExternalUrls
    var href: String
    var id: String
    var type: String
    var uri: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case type = "type"
        case uri = "uri"
    }
}
