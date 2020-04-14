//
//  ExternalUrls.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct ExternalUrls: Codable {
    var spotify: String

    enum CodingKeys: String, CodingKey {
        case spotify = "spotify"
    }
}
