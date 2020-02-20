//
//  TrackResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct TrackResult: Codable {
    let href: String
    let items: [Track]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
