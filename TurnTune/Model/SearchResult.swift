//
//  SearchResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let tracks: Tracks
}

// MARK: - Tracks
struct Tracks: Codable {
    let items: [Track]
}
