//
//  PlaylistTrackResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/24/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct PlaylistTrackResult: Codable {
    let href: String
    let items: [PlaylistTrack]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
