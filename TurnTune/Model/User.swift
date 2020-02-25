//
//  Followers.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct User: Codable {
    var displayName: String?
    var externalUrls: ExternalUrls
    var href: String
    var id, type, uri: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}
