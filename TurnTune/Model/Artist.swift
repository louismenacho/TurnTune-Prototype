//
//  Artist.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Artist: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let popularity: Int
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}
