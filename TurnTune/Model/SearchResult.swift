//
//  SearchResult.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let albums: AlbumResult?
    let artists: ArtistResult?
    let tracks: TrackResult?
    let playlists: PlaylistResult?
}
