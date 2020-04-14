//
//  SearchResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var tracks: Paging<Track>

    enum CodingKeys: String, CodingKey {
        case tracks = "tracks"
    }
}
