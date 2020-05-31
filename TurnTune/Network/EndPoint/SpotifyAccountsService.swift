//
//  SpotifyAccountsService.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyAccountsService {
    case authorize(_ clientID: String, _ redirectURI: String)
}

extension SpotifyAccountsService: Endpoint {
   
    var baseURL: String {
        "https://accounts.spotify.com"
    }
    
    var path: String {
        switch self {
        case .authorize:
            return "/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var parameters: HTTPParameters? {
        switch self {
        case let .authorize(cliendID, redirectURI):
            return [
                "client_id": cliendID,
                "redirect_uri": redirectURI,
                "response_type": "code",
                "scope": "playlist-modify-private"
            ]
        }
    }
    
    var headerField: HTTPHeaderField? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var contentType: HTTPContentType? {
        switch self {
        case .authorize:
            return nil
        }
    }
}
