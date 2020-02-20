//
//  PlaylistResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct PlaylistResult: Codable {
    let href: String
    let items: [Playlist]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
