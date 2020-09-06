//
//  SpotifyConstants.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/1/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Spotify {
    static let ClientID = "695de2c68a184c69aaebdf6b2ed02260"
    static let RedirectURL = "TurnTune://spotify-login-callback"
    static let TokenSwapURL = "https://turntune-spotify-token-swap.herokuapp.com/api/token"
    static let TokenRefreshURL = "https://turntune-spotify-token-swap.herokuapp.com/api/refresh_token"
}
